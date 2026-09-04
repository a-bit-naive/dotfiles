local M = {}

local function get_file_icon()
  local filename = vim.fn.expand("%:t")
  local extension = vim.fn.expand("%:e")

  if vim.icon then
    local icon = vim.icon.get({ name = filename, extension = extension })
    if icon then return icon .. " " end
  end

  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if has_devicons then
    local icon = devicons.get_icon(filename, extension, { default = true })
    if icon then return icon .. " " end
  end

  return "󰈔 "
end

local function get_lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return "None"
  end
  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  return table.concat(names, ", ")
end

local function get_diagnostics()
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

  local err_str = "%#StatusError#E:" .. errors .. "%*"
  local warn_str = "%#StatusWarn#W:" .. warnings .. "%*"

  return err_str .. " " .. warn_str
end

function _G.simple_statusline()
  local line = vim.fn.line(".")
  local col  = vim.fn.col(".")
  local formatted_pos = string.format("%3d:%-3d", line, col)

  local icon      = "%#StatusIcon# " .. get_file_icon() .. "%*"
  local file_path = "%#StatusFilename#" .. vim.fn.expand("%:p:~:h:t") .. "/" .. vim.fn.expand("%:t") .. "%*"
  local modified  = "%#StatusModified#%m%*"
  local readonly  = "%#StatusModified#%r%*"
  local line_info = "%#StatusLineInfo# " .. formatted_pos .. "%*"

  local align_right = "%="

  local lsp_info    = "%#StatusLsp#Lsp: " .. get_lsp_clients() .. "%*"
  local separator   = "%#StatusSep# | %*"
  local diagnostics = get_diagnostics() .. "    "

  return table.concat({
    icon, file_path, modified, readonly, "%#StatusSep# |%*", line_info,
    align_right,
    lsp_info, separator, diagnostics
  })
end

function M.setup()
  local bg_active   = "#1E1A2E"
  local bg_inactive = "#12101C"

  vim.api.nvim_set_hl(0, "StatusLine",   { bg = bg_active, fg = "#C0CAF5" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = bg_inactive, fg = "#4A4656" })

  vim.api.nvim_set_hl(0, "StatusIcon",     { fg = "#B4F9F8", bg = bg_active })
  vim.api.nvim_set_hl(0, "StatusFilename", { fg = "#C792EA", bg = bg_active, bold = true })
  vim.api.nvim_set_hl(0, "StatusLineInfo", { fg = "#A9B1D6", bg = bg_active })
  vim.api.nvim_set_hl(0, "StatusLsp",      { fg = "#BB9AF7", bg = bg_active, bold = true })
  vim.api.nvim_set_hl(0, "StatusSep",      { fg = "#3B3352", bg = bg_active })
  vim.api.nvim_set_hl(0, "StatusModified", { fg = "#FF757F", bg = bg_active })

  vim.api.nvim_set_hl(0, "StatusError", { fg = "#F7768E", bg = bg_active, bold = true })
  vim.api.nvim_set_hl(0, "StatusWarn",  { fg = "#E0AF68", bg = bg_active, bold = true })

  vim.opt.statusline = "%!v:lua.simple_statusline()"
end

return M
