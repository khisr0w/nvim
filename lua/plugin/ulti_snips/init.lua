platform = require("platform")
if platform.name == "windows" then
    vim.g.UltiSnipsSnippetDirectories = {
        "C:/Users/Khisrow/AppData/Local/nvim/lua/plugin/ulti_snips"
    }
    vim.g.UltiSnipsExpandTrigger = '<tab>'
    vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
    vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
    vim.g.UltiSnipsNoPythonWarning = 1
    vim.g.UltiSnipsAutoTrigger = 0
    vim.g.UltiSnipsUsePythonVersion = ''
elseif platform.name == "linux" or platform.name == "linux" then
    vim.notify("Ultisnips not set up for linux/macos")
end

