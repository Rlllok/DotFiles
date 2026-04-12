vim.cmd("highlight clear")

vim.o.background = "dark"

local colors = {
  bg      = "#1e2528",
  fg      = "#ffe9c4",
  yellow  = "#ffd866",
  red     = "#ff87a8",
  green   = "#8acfd1",
  blue    = "#ff8a66",
  purple  = "#d5b9ff",
  cyan    = "#a5f2e0",
  gray    = "#6b6f88",
  comment = "#8a8fa3",
  line    = "#3a4246",
}

local function set_hl(group, attrs)
  vim.api.nvim_set_hl(0, group, attrs)
end

-- Core groups (must set these)
set_hl("Normal",     { fg = colors.fg, bg = colors.bg })
set_hl("Comment",    { fg = colors.comment, italic = true })
set_hl("Constant",   { fg = colors.fg })
set_hl("String",     { fg = colors.green })
set_hl("Character",  { fg = colors.green })
set_hl("Number",     { fg = colors.fg })
set_hl("Boolean",    { fg = colors.fg })
set_hl("Float",      { fg = colors.fg })

set_hl("Identifier", { fg = colors.fg })
set_hl("Function",   { fg = colors.fg })

set_hl("Statement",  { fg = colors.fg })
set_hl("Conditional",{ fg = colors.fg })
set_hl("Repeat",     { fg = colors.fg })
set_hl("Label",      { fg = colors.fg })
set_hl("Operator",   { fg = colors.fg })
set_hl("Keyword",    { fg = colors.fg })
set_hl("Exception",  { fg = colors.fg })

set_hl("PreProc",    { fg = colors.purple })
set_hl("Include",    { fg = colors.purple })
set_hl("Define",     { fg = colors.purple })
set_hl("Macro",      { fg = colors.blue })
set_hl("PreCondit",  { fg = colors.purple })

set_hl("Type",        { fg = colors.fg })
set_hl("StorageClass",{ fg = colors.fg })
set_hl("Structure",   { fg = colors.fg })
set_hl("Typedef",     { fg = colors.fg })

set_hl("Special",        { fg = colors.fg })
set_hl("SpecialChar",    { fg = colors.fg })
set_hl("Tag",            { fg = colors.fg })
set_hl("Delimiter",      { fg = colors.fg })
set_hl("SpecialComment", { fg = colors.comment })

set_hl("Underlined", { fg = colors.blue, underline = true })
set_hl("Ignore",     { fg = colors.bg })
set_hl("Error",      { fg = colors.red, bg = colors.bg, bold = true })
set_hl("Todo",       { fg = colors.yellow, bg = colors.bg, bold = true })

-- UI / modern groups
set_hl("CursorLine",   { bg = colors.line })
set_hl("LineNr",       { fg = colors.gray })
set_hl("CursorLineNr", { fg = colors.yellow })
set_hl("SignColumn",   { bg = colors.bg })
set_hl("StatusLine",   { fg = colors.yellow, bg = colors.bg, bold = true })
set_hl("StatusLineNC", { fg = colors.fg, bg = colors.bg })
set_hl("Pmenu",        { fg = colors.fg, bg = colors.bg })
set_hl("PmenuSel",     { fg = colors.fg, bg = colors.line })
set_hl("PmenuSbar",    { bg = colors.yellow })
set_hl("PmenuThumb",   { bg = colors.fg })

-- Treesitter (modern syntax highlighting)
set_hl("@variable",         { fg = colors.fg })
set_hl("@function",         { fg = colors.fg })
set_hl("@constructor",      { fg = colors.fg })
set_hl("@keyword",          { fg = colors.red })
set_hl("@string",           { fg = colors.green })
set_hl("@comment",          { fg = colors.comment })
set_hl("@type",             { fg = colors.fg })
set_hl("@constant",         { fg = colors.fg })
-- Add more @lsp.* or @markup.* groups as needed

-- LSP / Diagnostics
set_hl("DiagnosticError",   { fg = colors.red })
set_hl("DiagnosticWarn",    { fg = colors.yellow })
set_hl("DiagnosticInfo",    { fg = colors.blue })
set_hl("DiagnosticHint",    { fg = colors.cyan })

-- Treesitter Context
set_hl("TreesitterContext",           { bg = colors.bg })
set_hl("TreesitterContextLineNumber", { bg = colors.bg })
set_hl("TreesitterContextSeparator",  { bg = colors.bg })
