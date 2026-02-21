vim.cmd("highlight clear")

vim.o.background = "dark"

local colors = {
  bg      = "#1e2528",
  fg      = "#ffe9c4",
  gray0   = "#2c3437",     -- very dark (almost bg)
  gray1   = "#3a4246",     -- line / selection
  gray2   = "#4f565c",     -- darker ui elements
  gray3   = "#6b6f88",     -- original gray
  gray4   = "#8a8fa3",     -- original comment
  gray5   = "#a8abb9",     -- lighter gray
  gray6   = "#c5c8d1",     -- even lighter
  -- Very muted accents — only used sparingly
  yellow  = "#c5a36c",     -- heavily desaturated yellow
  red     = "#d18a9c",     -- very muted red/pink
  cyan    = "#8ab2a9",     -- muted cyan
}

local function set_hl(group, attrs)
  vim.api.nvim_set_hl(0, group, attrs)
end

-- ── Core groups ─────────────────────────────────────────────────────
set_hl("Normal",       { fg = colors.fg, bg = colors.bg })
set_hl("Comment",      { fg = colors.gray4, italic = true })
set_hl("Constant",     { fg = colors.fg })                -- was purple
set_hl("String",       { fg = colors.gray5, italic = true })  -- softer than before
set_hl("Character",    { fg = colors.gray5, italic = true })
set_hl("Number",       { fg = colors.gray6 })
set_hl("Boolean",      { fg = colors.fg, bold = false })
set_hl("Float",        { fg = colors.gray6 })

set_hl("Identifier",   { fg = colors.fg })
set_hl("Function",     { fg = colors.fg, bold = false })   -- ← main change: no more blue

set_hl("Statement",    { fg = colors.fg, bold = false })
set_hl("Conditional",  { fg = colors.fg, bold = false })
set_hl("Repeat",       { fg = colors.fg, bold = false })
set_hl("Label",        { fg = colors.fg, bold = false })
set_hl("Operator",     { fg = colors.fg })
set_hl("Keyword",      { fg = colors.fg, bold = false })   -- ← most important: keywords = bold fg
set_hl("Exception",    { fg = colors.fg, bold = false })

set_hl("PreProc",      { fg = colors.gray5 })
set_hl("Include",      { fg = colors.gray5 })
set_hl("Define",       { fg = colors.gray5 })
set_hl("Macro",        { fg = colors.fg, bold = true })
set_hl("PreCondit",    { fg = colors.gray5 })

set_hl("Type",         { fg = colors.fg, bold = true })   -- types = bold instead of yellow
set_hl("StorageClass", { fg = colors.fg, bold = true })
set_hl("Structure",    { fg = colors.fg, bold = true })
set_hl("Typedef",      { fg = colors.fg, bold = true })

set_hl("Special",      { fg = colors.gray5 })
set_hl("SpecialChar",  { fg = colors.gray5 })
set_hl("Tag",          { fg = colors.fg })
set_hl("Delimiter",    { fg = colors.fg })
set_hl("SpecialComment",{ fg = colors.gray4, italic = true })

set_hl("Underlined",   { fg = colors.gray6, underline = true })
set_hl("Ignore",       { fg = colors.bg })
set_hl("Error",        { fg = colors.red,   bold = true, underline = true })
set_hl("Todo",         { fg = colors.yellow, bg = colors.gray1, bold = true })

-- ── UI ──────────────────────────────────────────────────────────────
set_hl("CursorLine",   { bg = colors.gray1 })
set_hl("LineNr",       { fg = colors.gray3 })
set_hl("CursorLineNr", { fg = colors.yellow, bold = true })  -- small yellow kept for active line
set_hl("SignColumn",   { bg = colors.bg })
set_hl("StatusLine",   { fg = colors.fg, bg = colors.gray1, bold = true })
set_hl("StatusLineNC", { fg = colors.gray4, bg = colors.gray0 })
set_hl("Pmenu",        { fg = colors.fg, bg = colors.gray0 })
set_hl("PmenuSel",     { fg = colors.fg, bg = colors.gray2, bold = true })
set_hl("PmenuSbar",    { bg = colors.gray3 })
set_hl("PmenuThumb",   { bg = colors.gray5 })

-- ── Treesitter ──────────────────────────────────────────────────────
set_hl("@variable",         { fg = colors.fg })
set_hl("@function",         { fg = colors.fg, bold = false })
set_hl("@constructor",      { fg = colors.fg, bold = false })
set_hl("@keyword",          { fg = colors.fg, bold = false })
set_hl("@string",           { fg = colors.gray5, italic = true })
set_hl("@comment",          { fg = colors.gray4, italic = true })
set_hl("@type",             { fg = colors.fg, bold = true })
set_hl("@constant",         { fg = colors.fg })
set_hl("@constant.builtin", { fg = colors.fg, bold = true })
set_hl("@variable.builtin", { fg = colors.fg, italic = true })

-- ── LSP / Diagnostics ───────────────────────────────────────────────
set_hl("DiagnosticError",   { fg = colors.red,    bold = true })
set_hl("DiagnosticWarn",    { fg = colors.yellow, bold = true })
set_hl("DiagnosticInfo",    { fg = colors.gray5 })
set_hl("DiagnosticHint",    { fg = colors.cyan })

-- Treesitter Context (very subtle)
set_hl("TreesitterContext",           { bg = colors.gray0 })
set_hl("TreesitterContextLineNumber", { fg = colors.gray3, bg = colors.gray0 })
set_hl("TreesitterContextSeparator",  { fg = colors.gray2, bg = colors.gray0 })
