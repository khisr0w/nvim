platform = require("platform")

-- Update tags on nvim open and file save (if ctags in PATH)
-- if vim.fn.executable("ctags") == 1 then
--     vim.cmd("cd E:\\")
--     local file_pattern = {"*.c", "*.cpp", "*.h", "*.hpp"}
--     local function ctags_func()
--         -- run_command_async("pushd .. && ctags && popd", {}, function(code, signal) end)
--         vim.fn.system("pushd .. && ctags && popd")
--     end
--     vim.api.nvim_create_autocmd("VimEnter", {
--         pattern = file_pattern,
--         callback = ctags_func
--     })
--     vim.api.nvim_create_autocmd("BufWritePost", {
--         pattern = file_pattern,
--         callback = ctags_func
--     })
-- else
--     print("ctags not in PATH. Disable tag generation.")
-- end


-- Insert date and time
vim.api.nvim_create_user_command("Date", function()
    local date = os.date(" - %d.%b.%Y")
    vim.api.nvim_put({date}, 'c', true, true)
    vim.cmd("normal " .. #date .. "h")
end, {})
vim.api.nvim_create_user_command("Time", function()
    local time = os.date("*t")
    local time_string = time.hour .. ":" .. time.min
    vim.api.nvim_put({time_string}, 'c', true, true)
    vim.cmd("normal " .. #time_string .. "h")
end, {})
vim.api.nvim_set_keymap("i", "<C-u>", "<Esc>:Date<CR>i", { noremap = true, silent = true })

if platform.name == "darwin" then
    vim.api.nvim_set_keymap("n", "˙", "<Esc><C-w>h", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "∆", "<Esc><C-w>j", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "˚", "<Esc><C-w>k", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "¬", "<Esc><C-w>l", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("i", "˙", "<Esc><C-w>h", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("i", "∆", "<Esc><C-w>j", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("i", "˚", "<Esc><C-w>k", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("i", "¬", "<Esc><C-w>l", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("i", "<C-h>", "<Esc>:Date<CR>i", { noremap = true, silent = true })
-- :nnoremap <A-h> <C-w>h
-- :nnoremap <A-j> <C-w>j
-- TODO(abid): Add the windows/linux keybindings from above here.
end

-- NOTE(abid): C/CPP compile
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.c", "*.cpp", "*.h", "*.hpp"},
    callback = function()
        vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:wa<CR>:call CompileSilent()<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<C-s>", ":wa<CR>:call CompileSilent()<CR>", { noremap = true, silent = true })
    end
})

-- NOTE(abid): Python linter (must have `ruff`)
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.py"},
    callback = function()
        local command = ':silent cgete system("ruff check .")<CR>'
        vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>" .. command, { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<C-s>", command, { noremap = true, silent = true })
    end
})

local comment_multi_line_set = function(start, end_)
    modes = {
        {name = "i", enter = ""},
        {name = "n", enter = "O"},
    }
    cats = {
        {name = " NOTE(abid):  ", keymap = "<C-j>"},
        {name = " TODO(abid):  ", keymap = "<C-k>"},
        {name = " WARNING(abid):  ", keymap = "<C-l>"},
    }

    for _, mode in ipairs(modes) do
        for _, cat in ipairs(cats) do
            vim.api.nvim_set_keymap(
                mode.name, cat.keymap,
                mode.enter .. start .. cat.name .. end_ .."<Esc>" .. string.rep("h", #end_) .. "i",
                { noremap = true, silent = true }
            )
        end
    end
end

local comment_single_line_set = function(prefix)
    modes = {"i", "n"}
    cats = {
        {name = " NOTE(abid):  ", keymap = "<C-j>"},
        {name = " TODO(abid):  ", keymap = "<C-k>"},
        {name = " WARNING(abid):  ", keymap = "<C-l>"},
    }
    for _, mode in ipairs(modes) do
        for _, cat in ipairs(cats) do
            vim.api.nvim_set_keymap(mode, cat.keymap, prefix .. cat.name, { noremap = true, silent = true })
        end
    end
end

-- Key mapping for C-style comment categories
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.c", "*.cpp", "*.h", "*.hpp", "*.js", "*.css", "*.jai"},
    callback = function()
        comment_multi_line_set("/*", "*/")
    end
})

-- Key mapping for Python comment categories
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.py", "*.sh", "*.bash"},
    callback = function()
        comment_single_line_set("#")
    end
})

-- Key mapping for Lua comment categories
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.lua"},
    callback = function()
        comment_single_line_set("--")
    end
})

-- Key mapping for batch file comment
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.bat", "*.batch"},
    callback = function()
        comment_single_line_set("rem")
    end
})

-- Key mapping for latex file(s) comment
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.tex"},
    callback = function()
        set_single_line_comment("%")
    end
})
