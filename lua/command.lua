plt = require("platform")
-- Generate CMake build
vim.api.nvim_create_user_command("CMake", function()
    local output = vim.fn.system(
        'pushd .. && ' ..
        '(if not exist binary ( mkdir binary ) else ( del /Q binary )) && ' ..
        'cd binary && ' ..
        'cmake -GNinja .. && ' ..
        'popd'
    )
    print(output)
end, {})

local function get_num_errors()
    return #vim.tbl_filter(function(item) return item.type == "e" end, vim.fn.getqflist())
end

local function run_build(current_dir, build_path)
    vim.fn.chdir(vim.fs.dirname(build_path))
    vim.cmd("cgete system('" .. build_path .. "')")
    vim.fn.chdir(current_dir)
    if get_num_errors() > 0 then
        vim.cmd("silent cc 1")
        vim.cmd("wa")
        vim.cmd("cl")
    end
end

local function compile_build(current_dir, build_src_path)
    vim.fn.chdir(vim.fs.dirname(build_src_path))
    vim.cmd("cgete system('" .. plt.preferred_compiler .. " " .. build_src_path .. "')")
    vim.fn.chdir(current_dir)
    if get_num_errors() > 0 then
        vim.cmd("silent cc 1")
        vim.cmd("wa")
        vim.cmd("cl")
    end
end

vim.api.nvim_create_user_command("Build", function()
    if plt.name == "windows" then build_filename = "build.exe" else build_filename = "build" end
    build_src_filename = "build.c"
    current_dir = vim.fn.getcwd()

    build_path = vim.fn.findfile(build_filename, current_dir .. ";")
    if #build_path > 0 then
        run_build(current_dir, build_path)
    else
        build_src_path = vim.fn.findfile(build_src_filename, current_dir .. ";")
        if #build_src_path > 0 then
            compile_build(current_dir, build_src_path)
        end
    end
end, {})
