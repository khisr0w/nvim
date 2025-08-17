utils = require("utils")

-- Example Cases
-- Plug('scrooloose/nerdtree', {on = 'NERDTreeToggle'})
-- Plug('scrooloose/nerdtree', {on = {'NERDTreeToggle', 'NERDTree'})
-- Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install']})

-- Plug('junegunn/fzf', {
--   ['do'] = function()
--     vim.call('fzf#install')
--   end
-- })
--
local Plug = vim.fn['plug#']
vim.call('plug#begin')
-------------- START --------------


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
if utils.check_args("snip") then
    Plug 'sirver/ultisnips'
end

-------------- END --------------
vim.call('plug#end')
