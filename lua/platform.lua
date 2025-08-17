local M = {}

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    M.name = "windows"
    M.path_sep = "\\"
    M.shell_path = "E:\\vendors\\nu\\nu"
    M.home = "E:\\"
elseif vim.fn.has("unix") == 1 and vim.fn.has("macunix") == 0 then
    M.name = "linux"
    M.path_sep = "/"
    M.shell_path = "/bin/bash"
    M.home = "~"
elseif vim.fn.has("macunix") == 1 then
    M.name = "darwin"
    M.path_sep = "/"
    M.shell_path = "/opt/homebrew/bin/nu"
    M.home = "~"
elseif vim.fn.has("wsl") == 1 then
    M.name = "wsl"
    M.path_sep = "/"
    M.shell_path = "/bin/bash"
    M.home = "~"
else
    return vim.alert("Unknown platform.")
end

return M
