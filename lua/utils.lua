return {
    font_size_step = function(font_str, offset)
        start_pos = string.find(font_str, ":")
        end_pos = string.find(font_str, ":", start_pos+1)
        prefix = string.sub(font_str, 0, start_pos+1)
        font_size = tonumber(string.sub(font_str, start_pos+2, end_pos-1)) + offset
        suffix = string.sub(font_str, end_pos)

        vim.opt.guifont = prefix .. font_size ..suffix
    end,

    check_args = function(flag)
        for _, arg in ipairs(vim.v.argv) do
            if arg == flag then
                return true
            end
        end
        return false
    end,
    run_command_async = function(command, args, callback)
        local stdout = vim.loop.new_pipe(false)
        local stderr = vim.loop.new_pipe(false)
        local handle

        local function on_exit(code, signal)
            stdout:close()
            stderr:close()
            handle:close()
            if callback then
                callback(code, signal)
            end
        end

        handle = vim.loop.spawn(
            command,
            {
                args = args,
                stdio = {nil, stdout, stderr},
            },
            on_exit
        )

        vim.loop.read_start(stdout, vim.schedule_wrap(function(err, data)
            -- if err then
            --     print("Error reading stdout:", err)
            -- elseif data then
            --     print("stdout:", data)
            -- end
        end))

        vim.loop.read_start(stderr, vim.schedule_wrap(function(err, data)
            if err then
                print("Error reading stderr:", err)
            elseif data then
                print("stderr:", data)
            end
        end))
    end,
    string_split = function(str, delim)
        local t = {}
        for substr in str.gmatch(str, "([^" .. delim .. "]+)") do
            table.insert(t, substr)
        end

        return t
    end,
}
