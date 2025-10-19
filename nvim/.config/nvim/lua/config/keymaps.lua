local map = vim.keymap.set

-- Close current buffer
map("n", "<leader>x", ":bd<CR>", { noremap = true, silent = true })

map("n", "J", "mzJ`z", { desc = "Keep the cursor at line start when executing the 'J' command" })

map("n", "<Esc>", "<Esc>:noh<CR>", { silent = true })

map("n", "<leader>:", "<cmd>lua require('fzf-lua').commands()<CR>", { noremap = true, silent = true })
