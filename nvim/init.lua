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
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {}, -- Empty opts uses default configuration
    config = function(_, opts)
    require("ibl").setup({
      enabled = false,
      indent = {
        char = '│',
        smart_indent_cap = true,
        priority = 2,
      },
      scope = {
        show_start = true,
        show_end = true,
      }
    })
    end,
  },
  "folke/zen-mode.nvim",
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
vim.keymap.set({"n", "v"}, "K","5k", {remap = true})
vim.keymap.set({"n", "v"}, "J", "5j", {remap = true})
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
    local content = file:read("*all")
    io.close(file)
    for word in content:gmatch("target = \"(%a+)\"") do
      target = word
    end
  end

  vim.keymap.set("n", "<space>bb", function()
    OpenTerminal()
    if system_name == "Windows_NT" then
      vim.fn.chansend(job_id, {"build" .. target .. "\r"})
    elseif system_name == "Linux" then
      vim.fn.chansend(job_id, {"sh build.sh " .. target .. "\r"})
    end
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
vim.lsp.enable("clangd");

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    vim.lsp.completion.enable(true, event.data.client_id, event.buf, {
      autotrigger = false,
    })

    local opts = {buffer = event.buf}
    -- Motion
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "F12", vim.lsp.buf.definition, opts)
    vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<C-h>", vim.lsp.buf.hover, opts)
    -- Editing
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  end,
})

vim.diagnostic.enable(false)

vim.cmd("colorscheme yellow")
