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
