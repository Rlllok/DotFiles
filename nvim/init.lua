vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.swapfile = false

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"},
  {
    "nvim-telescope/telescope.nvim",dependencies = { "nvim-lua/plenary.nvim" }
  },
})

-- Keymaps
vim.keymap.set({"n", "v"}, "K", "{zz", {remap = true})
vim.keymap.set({"n", "v"}, "J", "}zz", {remap = true})

vim.keymap.set("n", "<leader>ww", "<C-w>w", {remap = true})
vim.keymap.set("n", "<leader>ws", function() vim.cmd("vsplit") end)
vim.keymap.set("n", "<leader>wq", function() vim.cmd("q") end)

local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files)
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep)

vim.keymap.set("n", "<leader>-", "70A-<Esc>70d|", { remap = true })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

vim.defer_fn(function()
    require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp", "lua" },

        auto_install = false,

        hightlight = {
            enable = false,
            additional_vim_regex_highlighting = false,
        },
    })
end, 0)

-- Terminal ----------------------------------------------------------
local system_name = vim.loop.os_uname().sysname

local terminal_buffer = 0;
local job_id = 0;


function OpenTerminal()
	if terminal_buffer == 0 then
		vim.cmd.term()
		terminal_buffer = vim.api.nvim_get_current_buf()
		job_id = vim.bo.channel
	end
	vim.api.nvim_set_current_buf(terminal_buffer)
end

vim.keymap.set("n", "<space>wt", OpenTerminal)

vim.keymap.set("n", "<space>bb", function()
	OpenTerminal()
	if system_name == "Windows_NT" then
		vim.fn.chansend(job_id, {"build main\r"})
	elseif system_name == "Linux" then
		vim.fn.chansend(job_id, {"sh build.sh main\r"})
	end
end)
vim.keymap.set("n", "<space>br", function()
	OpenTerminal()
	if system_name == "Windows_NT" then
		vim.fn.chansend(job_id, {"build\\main\r"})
	elseif system_name == "Linux" then
		vim.fn.chansend(job_id, {"./build/main\r"})
	end
end)

-- Setup Custom Theme--------------------------------------------------
-- :h group-name - shows names of groups with explanation
-- :hi - to check all active groups
vim.o.background = "dark"
vim.o.cursorline = true
vim.cmd("syntax reset")
vim.o.termguicolors = true

-- local black = "#1A1E23"
local black        = "#121519"
local green        = "#9db989"
local earth_yellow = "#c69a60"
local cerise       = "#da4167"
local process_cyan = "#01baef"
local periwinkle   = "#C9DDFF"

local background_color         = "#2b292d"
local indentation_color        = "#2a2c30"
local cursor_background_color  = "#282E36"
local line_number_color        = "#999999"
local cursor_line_number_color = line_number_color
local normal_color             = "#fecdb2"
local comment_color            = "#81796f"
local string_color             = "#81796f"
local type_color               = earth_yellow
local identifier_color         = normal_color
local statement_color          = periwinkle
local operator_color           = "#e16785"
local function_color           = cerise
local preproc_color            = process_cyan
local enum_member_color        = "#f3ffc9"

vim.api.nvim_set_hl(0, "LineNr",               { fg = line_number_color })
vim.api.nvim_set_hl(0, "CursorLineNr",         { fg = cursor_line_number_color, bg = cursor_background_color})
-- Text
vim.api.nvim_set_hl(0, "Normal",               { fg = normal_color, bg = background_color })
vim.api.nvim_set_hl(0, "Visual",               { bg = "#595b5e"})
vim.api.nvim_set_hl(0, "Pmenu",                { fg = normal_color, bg = background_color })
vim.api.nvim_set_hl(0, "Identifier",           { fg = identifier_color })
vim.api.nvim_set_hl(0, "Constant",             { fg = type_color })
vim.api.nvim_set_hl(0, "Type",                 { fg = type_color })
vim.api.nvim_set_hl(0, "Function",             { fg = function_color })
vim.api.nvim_set_hl(0, "PreProc",              { fg = preproc_color })
vim.api.nvim_set_hl(0, "Statement",            { fg = statement_color })
vim.api.nvim_set_hl(0, "Operator",             { fg = operator_color })
vim.api.nvim_set_hl(0, "Comment",              { fg = comment_color })
vim.api.nvim_set_hl(0, "CursorLine",           { bg = cursor_background_color })
vim.api.nvim_set_hl(0, "@lsp.type.enumMember", { fg = enum_member_color })
vim.api.nvim_set_hl(0, "NonText",              { fg = cerise})

