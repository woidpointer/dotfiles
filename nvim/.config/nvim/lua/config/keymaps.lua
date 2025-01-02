local map = vim.keymap.set

-- neo-tree
-- TODO: Move this to neotree plugin configuration file
--[[
map("n", "-", function()
  local reveal_file = vim.fn.expand("%:p")
  if reveal_file == "" then
    reveal_file = vim.fn.getcwd()
  else
    local f = io.open(reveal_file, "r")
    if f then
      f.close(f)
    else
      reveal_file = vim.fn.getcwd()
    end
  end
  require("neo-tree.command").execute({
    action = "focus", -- OPTIONAL, this is the default value
    source = "filesystem", -- OPTIONAL, this is the default value
    position = "left", -- OPTIONAL, this is the default value
    reveal_file = reveal_file, -- path to file or folder to reveal
    reveal_force_cwd = true, -- change cwd without asking if needed
  })
end, { desc = "Open neo-tree at current file or working directory" })
--]]

-- nvim-tree
-- TODO: Move this to nvim-ree plugin configuration file
vim.keymap.set("n", "-", function()
  local reveal_file = vim.fn.expand("%:p")
  if reveal_file == "" then
    reveal_file = vim.fn.getcwd()
  else
    local f = io.open(reveal_file, "r")
    if f then
      f:close()
    else
      reveal_file = vim.fn.getcwd()
    end
  end

  require("nvim-tree.api").tree.open({
    find_file = true, -- Opens the tree and focuses on the file
    update_root = true, -- Updates the root directory to match the file's location
  })

  -- Change the current working directory to the file's location
  if vim.fn.isdirectory(reveal_file) == 1 then
    vim.cmd("cd " .. reveal_file)
  else
    vim.cmd("cd " .. vim.fn.fnamemodify(reveal_file, ":h"))
  end
end, { desc = "Open nvim-tree at current file or working directory" })

-- Close current buffer
map("n", "<leader>x", ":bd<CR>", { noremap = true, silent = true })

map(
  "n",
  "J",
  "mzJ`z",
  { desc = "Keep the cursor at line start when executing the 'J' command" }
)
