vim.g.mapleader = ','
vim.g.maplocalleader = ','

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fs', telescope.grep_string, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})

vim.keymap.set('n', '<leader>fc', function()
  telescope.live_grep({
    prompt_title = "C/C++ Function Definition",
    vimgrep_arguments = {
      "rg", "-U", "-o", "--pcre2", "--type", "c", "--color=never",
      "--no-heading", "--with-filename", "--line-number", "--column",
    },
    on_input_filter_cb = function(input)
      if input and input ~= "" then
        local pattern = '^[^\\n]*' .. input .. '\\s*\\([^)]*\\)(?=\\s*\\{)'
        return {
          prompt = pattern,
          search = pattern
        }
      end
      return { prompt = input, search = input }
    end,
  })
end, { desc = "Live grep function definitions" })
