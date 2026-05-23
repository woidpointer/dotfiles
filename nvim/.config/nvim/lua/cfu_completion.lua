--- Blink-Source für cfu LSP Ref-Completion.
--- Workaround: cfu erkennt Ref-Werte ohne Komma am Zeilenende nicht.
--- Wir senden temporär eine Version mit Komma, fragen Completion ab, dann zurück.

local M = {}

function M.new()
	return setmetatable({}, { __index = M })
end

function M:get_trigger_characters()
	return { "/", '"' }
end

function M:get_completions(context, callback)
	local bufnr = vim.api.nvim_get_current_buf()
	if vim.bo[bufnr].filetype ~= "json5" then
		callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = {} })
		return function() end
	end

	local client = vim.lsp.get_clients({ bufnr = bufnr, name = "cfu" })[1]
	if not client then
		callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = {} })
		return function() end
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1] - 1, cursor[2]
	local line = vim.api.nvim_get_current_line()

	-- Nur für Ref-Werte: Cursor muss nach '"/' stehen
	if not line:sub(1, col):match('"/') then
		callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = {} })
		return function() end
	end

	-- Zeile ohne Komma -> temporär Komma anfügen damit cfu den Ref-Wert erkennt
	local patched_line = line
	if not line:match(",[ \t]*$") then
		patched_line = line:gsub("[ \t]*$", ",")
	end

	local all_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	if patched_line ~= line then
		all_lines[row + 1] = patched_line
		client:notify("textDocument/didChange", {
			textDocument = { uri = vim.uri_from_bufnr(bufnr), version = 9999 },
			contentChanges = { { text = table.concat(all_lines, "\n") } },
		})
	end

	local cancelled = false
	vim.defer_fn(function()
		if cancelled then return end
		local _, req_id = client:request("textDocument/completion", {
			textDocument = { uri = vim.uri_from_bufnr(bufnr) },
			position = { line = row, character = col },
			context = {
				triggerKind = vim.lsp.protocol.CompletionTriggerKind.TriggerCharacter,
				triggerCharacter = "/",
			},
		}, function(err, result)
			-- Echten Buffer wieder senden
			if patched_line ~= line then
				local real_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
				client:notify("textDocument/didChange", {
					textDocument = { uri = vim.uri_from_bufnr(bufnr), version = 10000 },
					contentChanges = { { text = table.concat(real_lines, "\n") } },
				})
			end

			if cancelled or err or result == nil then
				callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = {} })
				return
			end

			local raw = result.items or result
			if type(raw) == "table" and raw.items then raw = raw.items end

			local items = vim.tbl_map(function(item)
				return {
					label = item.label,
					detail = item.detail,
					documentation = item.documentation,
					kind = item.kind,
					insertText = item.label,
					textEdit = item.textEdit,
					-- Blink braucht client_id für resolve
					client_id = client.id,
					client_name = client.name,
				}
			end, raw)

			callback({
				is_incomplete_forward = false,
				is_incomplete_backward = false,
				items = items,
			})
		end, bufnr)

		return function()
			cancelled = true
			if req_id then client:cancel_request(req_id) end
		end
	end, 50)

	return function()
		cancelled = true
	end
end

return M
