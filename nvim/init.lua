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
vim.o.termguicolors = true

local colors = {
	bg = "#1A2F2A", -- Deep forest green
	fg = "#c1c99d", -- Light mossy text
	cursor = "#A8B5A2", -- Soft lichen
	selection = "#3A4F3A", -- Muted pine
	line_highlight = "#223B34", -- Dark evergreen
	keyword = "#6B8E23", -- Olive green
	string = "#8B5A2B", -- Bark brown
	comment = "#5E7B5E", -- Mossy gray-green
	func = "#9ACD32", -- Leafy green
	variable = "#A8B5A2", -- Lichen
	number = "#7BB37B", -- Fern green
	constant = "#4682B4", -- Stream blue
	class = "#3CB371", -- Forest green
	operator = "#c1c99d", -- Light mossy text
	tag = "#6B8E23", -- Olive green
	attribute = "#A8B5A2", -- Lichen
	border = "#3F4F3F", -- Pine shadow
	panel_bg = "#223B34", -- Dark evergreen
	status_bar = "#4A7043", -- Deep moss
	status_bar_fg = "#D9E4D8", -- Light mossy text
	tab_active = "#1A2F2A", -- Deep forest green
	tab_inactive = "#2E3F38" -- Shaded evergreen
}

local function set_colors(mode)
  local c = colors
  vim.api.nvim_set_hl(0, "Normal", { fg = c.fg, bg = c.bg })
  vim.api.nvim_set_hl(0, "Cursor", { fg = c.bg, bg = c.cursor })
  vim.api.nvim_set_hl(0, "Visual", { bg = c.selection })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = c.line_highlight })
  vim.api.nvim_set_hl(0, "Keyword", { fg = c.keyword})
  vim.api.nvim_set_hl(0, "Statement", { fg = c.keyword})
  vim.api.nvim_set_hl(0, "PreProc", { fg = c.keyword})
  vim.api.nvim_set_hl(0, "String", { fg = c.string })
  vim.api.nvim_set_hl(0, "Comment", { fg = c.comment})
  vim.api.nvim_set_hl(0, "Function", { fg = c.func })
  vim.api.nvim_set_hl(0, "Identifier", { fg = c.variable })
  vim.api.nvim_set_hl(0, "@variable", { fg = c.variable })
  vim.api.nvim_set_hl(0, "Number", { fg = c.number })
  vim.api.nvim_set_hl(0, "Constant", { fg = c.constant })
  vim.api.nvim_set_hl(0, "Type", { fg = c.class })
  vim.api.nvim_set_hl(0, "Operator", { fg = c.operator })
  vim.api.nvim_set_hl(0, "htmlTag", { fg = c.tag })
  vim.api.nvim_set_hl(0, "htmlArg", { fg = c.attribute })
  vim.api.nvim_set_hl(0, "LineNr", { fg = c.comment })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.fg, bold = true })
  vim.api.nvim_set_hl(0, "StatusLine", { fg = c.status_bar_fg, bg = c.status_bar })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = c.fg, bg = c.panel_bg })
  vim.api.nvim_set_hl(0, "TabLineSel", { fg = c.fg, bg = c.tab_active })
  vim.api.nvim_set_hl(0, "TabLine", { fg = c.fg, bg = c.tab_inactive })
  vim.api.nvim_set_hl(0, "VertSplit", { fg = c.border })
  vim.api.nvim_set_hl(0, "Pmenu", { fg = c.fg, bg = c.panel_bg })
  vim.api.nvim_set_hl(0, "PmenuSel", { fg = c.status_bar_fg, bg = c.status_bar })
end

set_colors("dark")
