if vim.g.neovide then
    vim.opt.guifont = "Iosevka:h11:b,i,u"
    vim.g.neovide_scale_factor = 1.0875
    vim.g.neovide_cursor_animation_length = 0.0
    vim.g.neovide_scroll_animation_length = 0.1
    vim.g.neovide_hide_mouse_when_typing = true

    function toggle_fullscreen()
        vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
    end
    vim.api.nvim_set_keymap(
        "n", "<F11>", 
        ":lua toggle_fullscreen()<CR>",
        {noremap = true, silent = true})
    vim.api.nvim_set_keymap(
        "n", "<C-->", 
        ":lua font_size_step(vim.opt.guifont._value, -1)<CR>",
        {noremap = true, silent = true})
    vim.api.nvim_set_keymap(
        "n", "<C-=>", 
        ":lua font_size_step(vim.opt.guifont._value, 1)<CR>",
        {noremap = true, silent = true})
end
