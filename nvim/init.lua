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

----------------------------------------------------------------------
-- Main
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.swapfile = false

----------------------------------------------------------------------
-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

----------------------------------------------------------------------
-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

----------------------------------------------------------------------
-- Visual
vim.opt.termguicolors = true
vim.opt.showmatch = true

----------------------------------------------------------------------
-- Files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.autoread = true

----------------------------------------------------------------------
-- Behavior
vim.opt.autochdir = false
vim.opt.path:append("**")
vim.opt.mouse = "a"

----------------------------------------------------------------------
-- Keymaps
-- Movement
vim.keymap.set({"n", "v"}, "K","{", {remap = true})
vim.keymap.set({"n", "v"}, "J", "}", {remap = true})
vim.keymap.set("n", "n", "nzzzv");
vim.keymap.set("n", "N", "Nzzzv");

-- Delete/Yanking
vim.keymap.set({"n", "v"}, "<leader>d", '"_d');

-- Windows
vim.keymap.set("n", "<leader>ww", "<C-w>w", {remap = true})
vim.keymap.set("n", "<leader>ws", function() vim.cmd("vsplit") end)
vim.keymap.set("n", "<leader>wq", function() vim.cmd("q") end)

-- Telescope
local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files)
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep)

vim.keymap.set("n", "<leader>-", "70A-<Esc>70d|", { remap = true })

-- Terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

----------------------------------------------------------------------
-- Treesitter
vim.defer_fn(function()
    require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp", "lua" },

        auto_install = false,

        highlight = {
            enable = true,
            additional_vim_regex_highlighting = true,
        },
    })
end, 0)

----------------------------------------------------------------------
-- Terminal
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

----------------------------------------------------------------------
-- LSP
vim.lsp.config.clangd = {
  cmd = {"clangd", "--background-index"},
  filetypes = {"c", "cpp"},
}
vim.lsp.enable("clangd");

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = {buffer = event.buf}
    -- Motion
    vim.keymap.set("n", "gD", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "F12", vim.lsp.buf.definition, opts)
    -- Editing
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  end,
})

vim.diagnostic.enable(false)

----------------------------------------------------------------------
-- Setup Custom Theme
-- :h group-name - shows names of groups with explanation
-- :hi - to check all active groups
vim.o.background = "dark"

local palette = {
	brunwick_green = "#34554B",
	reseda_green = "#737249",
	dark_green = "#263B25",
	field_drab = "#614E0A",
	smoky_black = "#070401",
	smoky_brown = "#140D04",
	ash_gray = "#b8bdb3",
	gunmetal = "#30373E",
	drab_dark_brown = "#2D2B0A",

	brown = "#8C4303",
	dark_moss_green = "#465902",
	log_cabin = "#191E15",
	oxley = "#6C9885",
	mongoose = "#BCAC84",
	black_olive = "#283021",
	slate_grey = "#6B7991",

  moonlit_silver = "#D8E2EB",
  midnight_blue = "#2C3E50",
  pale_mist = "#E8ECEF",
  soft_bamboo = "#A8B5A2",
  lunar_glow = "#F5F6E8",

  moonlit_night = "#1A1D26",
  misty_moonlight = "#C7CED8",
  incense_purple = "#B49FCC",
  sakura_petal = "#E8B4B8",
  bamboo_mist = "#768C79",
  moonlight_silver = "#C9D6E3",
  river_slate = "#A0B2C5",
  sandstone_beige = "#D4C5A0",
  pale_lotus_blue = "#95B8D1",
  soft_stone = "#AAAEB9",
  moon_dust = "#D0D4DC",
  ember_red = "#D88080",
}

local colors = {
	bg = palette.moonlit_night,
	--fg = palette.misty_moonlight,
	fg = palette.pale_lotus_blue,
	delimiter = palette.ash_gray,
	cursor = "#A8B5A2",
	selection = palette.black_olive,
	line_highlight = palette.moon_duts,
  line_number = palette.bamboo_mist,
  curso_line_number = palette.sakura_petal,
	keyword = palette.incense_purple,
	str = palette.sakura_petal,
	comment = palette.bamboo_mist,
	func = palette.ember_red,
	variable = fg,
	number = palette.sakura_petal,
	constant = palette.sakura_petal,
	special = palette.sakura_petal,
	type = palette.sandstone_beige,
  --type = palette.pale_lotus_blue,
	operator = palette.soft_stone,
	tag = "#6B8E23", -- Olive green
	attribute = "#A8B5A2", -- Lichen
	border = palette.ash_gray,
	panel_bg = "#223B34", -- Dark evergreen
	status_bar = palette.mi,
	status_bar_fg = palette.misty_moonlight,
}

local function set_colors(mode)
  local c = colors
  local transperent = true
  if transperent then
    vim.api.nvim_set_hl(0, "Normal", { fg = c.fg, bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { fg = c.fg, bg = "none" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = c.fg, bg = "none" })
  else
    vim.api.nvim_set_hl(0, "Normal", { fg = c.fg, bg = c.bg })
    vim.api.nvim_set_hl(0, "NormalNC", { fg = c.fg, bg = c.bg })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = c.fg, bg = c.bg })
  end
  vim.api.nvim_set_hl(0, "Cursor", { fg = c.bg, bg = c.cursor })
  vim.api.nvim_set_hl(0, "Visual", { bg = c.selection })
  vim.api.nvim_set_hl(0, "CursorLine", { bg = c.line_highlight })
  vim.api.nvim_set_hl(0, "Keyword", { fg = c.keyword})
  vim.api.nvim_set_hl(0, "Statement", { fg = c.keyword})
  vim.api.nvim_set_hl(0, "PreProc", { fg = c.keyword})
  vim.api.nvim_set_hl(0, "Special", { fg = c.special})
  vim.api.nvim_set_hl(0, "String", { fg = c.str })
  vim.api.nvim_set_hl(0, "Comment", { fg = c.comment})
  vim.api.nvim_set_hl(0, "Function", { fg = c.func })
  vim.api.nvim_set_hl(0, "@lsp.type.macro.c", { fg = c.func })
  vim.api.nvim_set_hl(0, "Identifier", { fg = c.variable })
  vim.api.nvim_set_hl(0, "@variable", { fg = c.variable })
  vim.api.nvim_set_hl(0, "Number", { fg = c.number })
  vim.api.nvim_set_hl(0, "Delimiter", { fg = c.delimiter })
  vim.api.nvim_set_hl(0, "Constant", { fg = c.constant })
  vim.api.nvim_set_hl(0, "Type", { fg = c.type })
  vim.api.nvim_set_hl(0, "Operator", { fg = c.operator })
  vim.api.nvim_set_hl(0, "htmlTag", { fg = c.tag })
  vim.api.nvim_set_hl(0, "htmlArg", { fg = c.attribute })
  vim.api.nvim_set_hl(0, "LineNr", { fg = c.line_number, bold = false })
  vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.cursor_line_number, bold = true })
  vim.api.nvim_set_hl(0, "StatusLine", { fg = c.fg, bg = c.status_bar, bold = true})
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = c.fg, bg = c.status_bar })
  vim.api.nvim_set_hl(0, "VertSplit", { fg = c.border })
  vim.api.nvim_set_hl(0, "Pmenu", { fg = c.fg, bg = c.panel_bg })
  vim.api.nvim_set_hl(0, "PmenuSel", { fg = c.status_bar_fg, bg = c.status_bar })
end

set_colors("dark")
