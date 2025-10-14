local set = vim.opt_local

set.number = false
set.relativenumber = false
set.wrap = true
set.linebreak = true
set.breakindent = true
set.spell = true
set.spelllang = {"en_us"}

vim.keymap.set({"n", "v"}, "j", "gj", {buffer = true})
vim.keymap.set({"n", "v"}, "k", "gk", {buffer = true})
