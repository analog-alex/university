local M = {}

M.base_30 = {
  white = "#cad3f5",
  darker_black = "#181926",
  black = "#24273a",
  black2 = "#2a2d42",
  one_bg = "#303347",
  one_bg2 = "#363a4f",
  one_bg3 = "#494d64",
  grey = "#5b6078",
  grey_fg = "#6e738d",
  grey_fg2 = "#8087a2",
  light_grey = "#939ab7",
  red = "#ed8796",
  baby_pink = "#f0c6c6",
  pink = "#f5bde6",
  line = "#3a3e53",
  green = "#a6da95",
  vibrant_green = "#b1e3a2",
  nord_blue = "#91d7e3",
  blue = "#8aadf4",
  yellow = "#eed49f",
  sun = "#f4dbb3",
  purple = "#c6a0f6",
  dark_purple = "#b38de9",
  teal = "#8bd5ca",
  orange = "#f5a97f",
  cyan = "#7dc4e4",
  statusline_bg = "#1f2232",
  lightbg = "#313548",
  pmenu_bg = "#a6da95",
  folder_bg = "#8aadf4",
  lavender = "#b7bdf8",
}

M.base_16 = {
  base00 = "#24273a",
  base01 = "#2a2d42",
  base02 = "#303347",
  base03 = "#363a4f",
  base04 = "#6e738d",
  base05 = "#b8c0e0",
  base06 = "#cad3f5",
  base07 = "#f4dbd6",
  base08 = "#ed8796",
  base09 = "#f5a97f",
  base0A = "#eed49f",
  base0B = "#a6da95",
  base0C = "#8bd5ca",
  base0D = "#8aadf4",
  base0E = "#c6a0f6",
  base0F = "#f0c6c6",
}

M.polish_hl = {
  treesitter = {
    ["@variable"] = { fg = M.base_30.lavender },
    ["@property"] = { fg = M.base_30.teal },
    ["@variable.builtin"] = { fg = M.base_30.red },
  },
}

M.type = "dark"

M = require("base46").override_theme(M, "catppuccin_macchiato")

return M
