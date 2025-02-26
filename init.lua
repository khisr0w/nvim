vim.cmd([[
let g:c_function_highlight = 1
let $TERM = 'conemu'
syntax on
set hlsearch
set incsearch
set backspace=indent,eol,start
set nowrap

set breakindent showbreak=..
set linebreak
"set foldmethod=indent foldcolumn=4
set tabstop=4 shiftwidth=4 expandtab

set cindent
set smartindent
set autoindent
set smarttab
set ignorecase
set smartcase
"set softtabstop=0 noexpandtab
set nonu
set norelativenumber
set cursorline
set belloff=all
set autochdir

"autocmd FileType help,* wincmd L
"au GUIEnter * simalt ~x
autocmd FileType make setlocal noexpandtab

autocmd BufNewFile,BufRead *.vs,*.fs set ft=glsl
"autocmd BufWritePost *.c,*.h system('pushd .. && ctags && popd')

hi Search ctermbg=white ctermfg=red
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

colorscheme gruvbox
"if has('gui_running')
"	set guioptions-=m  "menu bar
"	set guioptions-=T  "toolbar
"	set guioptions-=r  "scrollbar
"	set guioptions-=L  "scrollbar
"	set guifont=Fantasque_Sans_Mono:h10:cANSI:qDRAFT
"	colorscheme gruvbox
"	au GUIEnter * simalt ~x
"	nnoremap <C-S> :call CompileSilent()<CR>
"	inoremap <C-S> <Esc>:wa<CR>:call CompileSilent()<CR>
"endif

" ============================================================================

cd ~
cab scratch E:/den/content/posts/scratch.md
cab WA w
"cab cmd echo system("")<Left><Left>

"au VimEnter * silent call system('pushd ' . '"' . expand("$VIMRUNTIME") . '" ' . '& start /b escToCaps.exe & popd')
"au VimLeave * silent call system('taskkill /F /IM "escToCaps.exe"')

"au VimEnter * jobstart(['cmd.exe', 'ping neovim.io')

tnoremap <Esc> <C-\><C-n>
"set clipboard+=unnamedplus
set laststatus=2

hi Pmenu guibg=#504945
hi PmenuSel guibg=#ec524b

:tnoremap <A-h> <C-\><C-N><C-w>h
:tnoremap <A-j> <C-\><C-N><C-w>j
:tnoremap <A-k> <C-\><C-N><C-w>k
:tnoremap <A-l> <C-\><C-N><C-w>l
:inoremap <A-h> <C-\><C-N><C-w>h
:inoremap <A-j> <C-\><C-N><C-w>j
:inoremap <A-k> <C-\><C-N><C-w>k
:inoremap <A-l> <C-\><C-N><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l

nnoremap <C-S> <Esc>:wa<CR>:call CompileSilent()<CR>
inoremap <C-S> <Esc>:wa<CR>:call CompileSilent()<CR>

nnoremap <C-X> :silent !..\debug.bat<CR>

" key mapping for the quickfix jumps after compilation
:nnoremap <A-n> :cn<CR>
:nnoremap <A-b> :cN<CR>

nnoremap <A-s> <Esc>:wa<CR>:call CompileSilentAndRun()<CR>
":nnoremap <A-s> <Esc>:wa<CR>:silent call CompileSilentAndRun()<CR><C-w>p:q<CR>:cope<CR>

"au BufWinEnter *.cpp,*.c,*.h,*.hpp,*.bat cd %:p:h | cd /
au BufNewFile *.h,*.hpp silent w | HeaderNewFileTemplate() | cd %:p:h
au BufNewFile *.cpp,*.c silent w | CPPNewFileTemplate() | cd %:p:h
au BufUnload *.cpp,*.c,*.h,*.hpp call UpdateFile()

"echo bufname(1)

:set makeprg=cmd 
:set splitbelow
:set splitright

function! UpdateFile()
	let curpos = getcurpos()
	:0
	if(search('/\*', 'Wc') == 1)
		if(search('\(+======.*|.*File.*Info.*|\)', 'W') == 1)
			if(search('\(Last.*Modified.*:\)', 'W') == 5)
				if(search('\(|.*Copyright.*©.*Sayed.*Abid.*Hashimi.|\)', 'W') == 7)
					:0
					let line = search('\(Last.*Modified.*:\)', 'W')
					execute 'let text = "    |    Last Modified:  " . strftime("%c", localtime())'
					let i = 88 - len(text)
					while(i > 1)
						execute 'let text = text . " "'
						let i = i - 01
					endwhile
					execute 'let text = text . "|"'
					silent call setline(line, text)
				endif
			endif
		endif
	endif
	call setpos('.', [curpos[0], curpos[1], curpos[2], curpos[3] ])
endfunction

function! CompileSilentAndRun()
	:wa
	:call setqflist([], 'a', {'title' : 'Compilation and Run'})
	":silent cgete system('pushd .. && make -B run && popd')
	:silent cgete system('pushd .. && cd binary && cmake --build . && cmake --build . --target exec && popd')
	:silent cc 1
	:wa
	:cl
endfunction
function! CompileSilent()
	:wa
	:call setqflist([], 'a', {'title' : 'Compilation'})
	":silent cgete system('pushd .. && make -B debug && popd')
	:silent cgete system('pushd .. && cd binary && cmake --build . && popd')
	:silent cc 1
	:wa
	:cl
endfunction

function! CPPNewFileTemplate(...)

	execute 'let filemacro = toupper(expand("%:t:r")) . "_" . toupper(expand("%:e"))'
	execute 'let linenum = 1'
	let head = "/*  +======| File Info |===============================================================+"
	silent call appendbufline("", linenum, head)
	let linenum = linenum + 01
	let pad = "    |                                                                                  |"
	silent call appendbufline("", linenum, pad)
	let linenum = linenum + 01
	let end = "    +==================================================| Sayed Abid Hashimi |==========+  */"

	let subd = expand("%:p:h:t")
	let created = strftime("%c", getftime(expand("%:p")))
	execute 'let first = "    |     Subdirectory:  /" . subd'
	execute 'let second = "    |    Creation date:  " . created'
	execute 'let third = "    |    Last Modified:  "'
	let values = [first, second, third]

	let item = len(values)
	execute 'let i = 0'
	while(i < item)

		let j = len(head) - len(values[i])
		while(j > 1)
			execute 'let values[i] = values[i] . " "'
			let j = j - 01
		endwhile
		execute 'let values[i] = values[i] . "|"'
		silent call appendbufline("", linenum, values[i])
		let linenum = linenum + 01
		let i = i + 01
	endwhile
	silent call appendbufline("", linenum, pad)
	let linenum = linenum + 01
	silent call appendbufline("", linenum, end)
	let linenum = linenum + 01
	silent call appendbufline("", linenum, "")
	let linenum = linenum + 01
	:0
	execute 'normal dd'

endfunction

com! -nargs=* -complete=file CPPNewFileTemplate call CPPNewFileTemplate(<f-args>)

function! HeaderNewFileTemplate(...)

	execute 'let filemacro = toupper(expand("%:t:r")) . "_" . toupper(expand("%:e"))'
	execute 'let linenum = 1'
	let head = "/*  +======| File Info |===============================================================+"
	silent call appendbufline("", linenum, head)
	let linenum = linenum + 01
	let pad = "    |                                                                                  |"
	silent call appendbufline("", linenum, pad)
	let linenum = linenum + 01
	let end = "    +======================================| Copyright © Sayed Abid Hashimi |==========+  */"

	let subd = expand("%:p:h:t")
	let created = strftime("%c", getftime(expand("%:p")))
	execute 'let first = "    |     Subdirectory:  /" . subd'
	execute 'let second = "    |    Creation date:  " . created'
	execute 'let third = "    |    Last Modified:  "'
	let values = [first, second, third]

	let item = len(values)
	execute 'let i = 0'
	while(i < item)

		let j = len(head) - len(values[i])
		while(j > 1)
			execute 'let values[i] = values[i] . " "'
			let j = j - 01
		endwhile
		execute 'let values[i] = values[i] . "|"'
		silent call appendbufline("", linenum, values[i])
		let linenum = linenum + 01
		let i = i + 01
	endwhile
	silent call appendbufline("", linenum, pad)
	let linenum = linenum + 01
	silent call appendbufline("", linenum, end)
	let linenum = linenum + 01
	silent call appendbufline("", linenum, "")
	let linenum = linenum + 01
	silent call appendbufline("", linenum, "#if !defined(" . filemacro . ")")
	let linenum = linenum + 01

	execute 'let i = 10'
	while(i > 0)
		silent call appendbufline("", linenum, "")
		let linenum = linenum + 01
		let i = i - 01
	endwhile

	silent call appendbufline("", linenum, "#define " . filemacro)
	let linenum = linenum + 01
	silent call appendbufline("", linenum, "#endif")
	let linenum = linenum + 01
	:0
	execute 'normal dd'
endfunction
com! -nargs=* -complete=file HeaderNewFileTemplate call HeaderNewFileTemplate(<f-args>)

function! MakeProj(...)
	if(a:0 == 0)
		echoerr "Please provide the name for your project"
	else
		execute 'let name = a:1'
		silent execute '!mkdir ' . name
		execute 'cd ' . name
		if(a:0 == 2)
			if(!empty(bufname()))
				silent w
			endif
			execute 'e ' . a:2
			silent w
		endif
	endif
	echo "++++ Project Successfully Created ++++"
endfunction
com! -nargs=* -complete=file MakeProj call MakeProj(<f-args>)
cab makeproj MakeProj
]])

function font_size_step(font_str, offset)
    start_pos = string.find(font_str, ":")
    end_pos = string.find(font_str, ":", start_pos+1)
    prefix = string.sub(font_str, 0, start_pos+1)
    font_size = tonumber(string.sub(font_str, start_pos+2, end_pos-1)) + offset
    suffix = string.sub(font_str, end_pos)

    vim.opt.guifont = prefix .. font_size ..suffix
end

-- Neovide configs
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

local function check_cmd_flag(flag)
    for _, arg in ipairs(vim.v.argv) do
        if arg == flag then
            return true
        end
    end
    return false
end

-- vim-plug Plugins
local Plug = vim.fn['plug#']
vim.call('plug#begin')

-- Helper library for convenient routines
Plug 'nvim-lua/plenary.nvim'

-- GLSL Sytax highlighting
Plug 'tikhomirov/vim-glsl'

-- Telescope for nvim use of ripgrep
Plug('nvim-telescope/telescope.nvim', {tag = '0.1.2' })
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' })

-- Jai Syntax highlighting
Plug 'rluba/jai.vim'

-- Snippets 
if check_cmd_flag("snip") then
    Plug 'sirver/ultisnips'
end

vim.call('plug#end')

-- Ulti Snips configuration
vim.cmd([[
let g:UltiSnipsSnippetDirectories = ["C:/Users/Khisrow/AppData/Local/nvim"]
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsNoPythonWarning = 1
let g:UltiSnipsAutoTrigger = 0
let g:UltiSnipsUsePythonVersion = ''
]])

-- Example Cases
-- Plug('scrooloose/nerdtree', {on = 'NERDTreeToggle'})
-- Plug('scrooloose/nerdtree', {on = {'NERDTreeToggle', 'NERDTree'})
-- Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install']})

-- Plug('junegunn/fzf', {
--   ['do'] = function()
--     vim.call('fzf#install')
--   end
-- })

-- Telescope configuration
vim.g.mapleader = ','
vim.g.maplocalleader = ','

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fs', telescope.grep_string, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})

vim.api.nvim_set_var('terminal_emulator', 'cmd')

-- Call a command-line function asynchronously
local function run_command_async(command, args, callback)
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
end

-- Update tags on nvim open and file save (if ctags in PATH)
if vim.fn.executable("ctags") == 1 then
    vim.cmd("cd E:\\")
    local file_pattern = {"*.c", "*.cpp", "*.h", "*.hpp"}
    local function ctags_func()
        -- run_command_async("pushd .. && ctags && popd", {}, function(code, signal) end)
        vim.fn.system("pushd .. && ctags && popd")
    end
    vim.api.nvim_create_autocmd("VimEnter", {
        pattern = file_pattern,
        callback = ctags_func
    })
    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = file_pattern,
        callback = ctags_func
    })
else
    print("ctags not in PATH. Disable tag generation.")
end

function string_split(str, delim)
    local t = {}
    for substr in str.gmatch(str, "([^" .. delim .. "]+)") do
        table.insert(t, substr)
    end

    return t
end

-- Compile latex to PDF on save asynchronously
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = {"*.tex"},
    callback = function()
        local buffer = vim.api.nvim_get_current_buf()
        local file_name = vim.api.nvim_buf_get_name(buffer)
        run_command_async("latexmk", {"-pdf", "-outdir=build", file_name},
            function(code, signal)
                if code == 0 then
                    print("PDF compiled successfully.")
                else
                    print("Failed PDF compilation with code:", code, "signal:", signal, "retrying...")
                    local separator = package.config:sub(1, 1)
                    local name_without_path = string_split(file_name, separator)
                    local name_without_path = name_without_path[#name_without_path]
                    local aux_to_delete = vim.loop.cwd() .. separator .. "build".. separator .. string_split(name_without_path, ".")[1] .. ".aux"
                    local success = os.remove(aux_to_delete)
                    if success then
                        print("Deleted", aux_to_delete)
                        run_command_async("latexmk", {"-pdf", "-outdir=build", file_name}, nil)
                    else
                        print("Failed to delete", aux_to_delete)
                    end
                end
            end
        )
    end
})

-- Key mapping for C-style comment categories
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.c", "*.cpp", "*.h", "*.hpp", "*.js", "*.css"},
    callback = function()
        vim.api.nvim_set_keymap("i", "<C-j>", "/* NOTE(abid):  */<Esc>hhi", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<C-j>", "O/* NOTE(abid):  */<Esc>hhi", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("i", "<C-k>", "/* TODO(abid):  */<Esc>hhi", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<C-k>", "O/* TODO(abid):  */<Esc>hhi", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("i", "<C-l>", "/* WARNING(abid):  */<Esc>hhi", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<C-l>", "O/* WARNING(abid):  */<Esc>hhi", { noremap = true, silent = true })
    end
})

local set_single_line_comment = function(prefix)
    vim.api.nvim_set_keymap("i", "<C-j>", prefix .. " NOTE(abid): ", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("i", "<C-k>", prefix .. " TODO(abid): ", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("i", "<C-l>", prefix .. " WARNING(abid): ", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<C-k>", "O" .. prefix .. " TODO(abid): ", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<C-j>", "O" .. prefix .. " NOTE(abid): ", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<C-l>", "O" .. prefix .. " WARNING(abid): ", { noremap = true, silent = true })
end

-- Key mapping for Python comment categories
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.py", "*.sh", "*.bash"},
    callback = function()
        set_single_line_comment("#")
    end
})

-- Key mapping for Lua comment categories
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.lua"},
    callback = function()
        set_single_line_comment("--")
    end
})

-- Key mapping for batch file comment
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.bat", "*.batch"},
    callback = function()
        set_single_line_comment("rem")
    end
})

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
