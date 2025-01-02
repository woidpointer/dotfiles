return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        --[[
        -- Add here additional language server which should be installed
        --]]
        ensure_installed = {},
      })
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({

            on_init = function(client)
              if client.workspace_folders then
                local path = client.workspace_folders[1].name

                ---@diagnostic disable: undefined-field
                if
                  vim.loop.fs_stat(path .. "/.luarc.json")
                  or vim.loop.fs_stat(path .. "/.luarc.jsonc")
                then
                  return
                end
              end

              client.config.settings.Lua =
                vim.tbl_deep_extend("force", client.config.settings.Lua, {
                  runtime = {
                    version = "LuaJIT",
                  },
                  -- Make the server aware of Neovim runtime files
                  workspace = {
                    checkThirdParty = false,
                    library = {
                      vim.env.VIMRUNTIME,
                    },
                  },
                })
            end,
            settings = {
              Lua = {},
            },
          })
        end,
        ["clangd"] = function()
          require("lspconfig").clangd.setup({
            capabilities = {
              offsetEncoding = { "utf-16" },
            },
          })
        end,
        -- Add additional specializations
      })
    end,
  },
}
