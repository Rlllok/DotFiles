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
	{
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate"
  },
  {
    "nvim-telescope/telescope.nvim",dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
    "nvim-mini/mini.align", version = "*"
  },
  {
    "ludovicchabant/vim-gutentags",
    config = function()
      if vim.fn.has('macunix') then
        vim.g.gutentags_ctags_executable = "/opt/homebrew/bin/ctags"
      else
        vim.g.gutentags_ctags_executable = "ctags"
      end
      vim.g.gutentags_project_root = { ".git", ".hg", ".svn", "Makefile" }  -- project markers
      vim.g.gutentags_generate_on_new = 1
      vim.g.gutentags_generate_on_missing = 1
      vim.g.gutentags_generate_on_write = 1
      vim.g.gutentags_generate_on_empty = 0
      vim.g.gutentags_ctags_exclude = { ".git", "build", "data", "*.o" }
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = {
        preset = "default",
      },
      appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = "mono"
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        menu = {
          auto_show = true
        },
      },
      sources = {
        default = {"lsp", "path", "buffer"},
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },
})

require("mini.align").setup({})

----------------------------------------------------------------------
-- Main
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.swapfile = false

vim.opt.tags ="./tags;./tags"
vim.opt.tagcase = "followic"

--vim.o.langmap = "АБВГДЕЖЗИІЙКЛМНОПРСТУФХЦЧШЩЬЮЯабвгдежзиіїйклмнопрстуфхцчшщьюя,ҐЄІЇґєїі:ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,."
--vim.o.langremap = true

----------------------------------------------------------------------
-- Indentation
vim.cmd("filetype indent off")
vim.opt.expandtab = true
vim.opt.cindent = false
vim.opt.smartindent = false
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

----------------------------------------------------------------------
-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

----------------------------------------------------------------------
-- Visual
vim.opt.termguicolors = true
vim.opt.showmatch = true
vim.opt.guicursor = "n-v:block,i:hor20"
vim.opt.listchars = "tab: ,multispace:┊ "
vim.opt.list = false

local hightlight_group = vim.api.nvim_create_augroup("YankHighlight", {clear = true})
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function ()
    vim.highlight.on_yank({timeout = 160})
  end,
  group = highligh_group,
})

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
vim.opt.completeopt = {"menu", "noinsert", "noselect"}

----------------------------------------------------------------------
-- Keymaps
-- Movement
vim.keymap.set({"n", "v"}, "J","<C-d>zz", {noremap = true, remap = true})
vim.keymap.set({"n", "v"}, "K","<C-u>zz", {noremap = true, remap = true})
vim.keymap.set("n", "n", "nzzzv", {noremap = true, remap = true});
vim.keymap.set("n", "N", "Nzzzv", {noremap = true, remap = true});

-- Ctags
local function CTags_JumpToDefinitionOtherWindow()
  local tag_name = vim.fn.expand("<cword>")
  
  if tag_name == "" then
    return
  end

  vim.cmd("wincmd w")
  vim.cmd("tag " .. tag_name)
  vim.cmd("wincmd w")
end

vim.keymap.set("n", "<leader>gd", CTags_JumpToDefinitionOtherWindow, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gb", "<C-T>", {noremap = true, silent = true})

-- Delete/Yanking
vim.keymap.set({"n", "v"}, "<leader>d", '"_d');

-- Windows
local function ChangeWindow()
  if (vim.fn.winnr("$") > 1) then
    local total_width = vim.o.columns
    local target_width = math.floor(total_width*0.6)

    vim.cmd("wincmd w")
    vim.api.nvim_win_set_width(0, target_width)
  end
end
vim.keymap.set("n", "<leader>ww", ChangeWindow, {remap = true})
vim.keymap.set("n", "<leader>ws", function() vim.cmd("vsplit") end)
vim.keymap.set("n", "<leader>wq", function() vim.cmd("q") end)

-- Telescope
local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", function() telescope_builtin.find_files({hidden = true}) end)
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep)

vim.keymap.set("n", "<leader>-", "70A-<Esc>70d|", { remap = true })

-- Terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

----------------------------------------------------------------------
-- Treesitter
vim.defer_fn(function()
    require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp", "lua", "go", "html", "markdown" },

        auto_install = false,

        indent = {
          enable = false,
        },

        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
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

----------------------------------------------------------------------
-- Project
function SetBuildTargetKeybind()
  local target = "main"

  local file_path = vim.fn.getcwd() .. "/.nvim.project"
  if vim.fn.filereadable(file_path) then
    local file = io.open(file_path)
    if file then
      local content = file:read("*all")
      for word in content:gmatch("target = \"(%a+)\"") do
        target = word
      end
      io.close(file)
    end
  end


  vim.keymap.set("n", "<space>bb", function()
    -- OpenTerminal()

    local build_cmd = "";
    if system_name == "Windows_NT" then
      build_cmd = string.format("build %s nul 2>&1", target)
    elseif system_name == "Linux" then
      build_cmd = string.format("sh build.sh %s nul 2>&1", target)
    elseif vim.fn.has('macunix') then
      build_cmd = string.format("sh build_macos.sh %s nul 2>&1", target)
    end

    local current_time = vim.fn.strftime("%H:%M:%S")
    local output = vim.fn.system(build_cmd)

    vim.fn.setqflist({}, "r", {
      title = string.format("[%s] [%s] -- Compilation Result --", target, current_time),
      lines = vim.split(output, "\n"),
    })

    vim.cmd("silent! wincmd o")
    vim.cmd("silent! vert copen")
    vim.cmd("silent! wincmd p")
    vim.cmd("silent! wincmd =")
  end)
end

vim.keymap.set("n", "<space>pr", SetBuildTargetKeybind)

vim.api.nvim_create_autocmd("VimEnter", {callback = SetBuildTargetKeybind})

----------------------------------------------------------------------
-- LSP
vim.lsp.config.clangd = {
  cmd = {"clangd", "--background-index"},
  filetypes = {"c", "cpp"},
}
-- vim.lsp.enable("clangd");

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    vim.lsp.completion.enable(true, event.data.client_id, event.buf, {
      autotrigger = false,
    })

    local opts = {buffer = event.buf}
    -- Motion
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    -- Help
    --vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, opts)
    vim.keymap.set("i", "<C-h>",     vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<C-h>",     vim.lsp.buf.hover, opts)
    -- Editing
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  end,
})

vim.diagnostic.enable(true)
vim.diagnostic.config({virtual_text = true})

vim.cmd("colorscheme yellow_minimal")
