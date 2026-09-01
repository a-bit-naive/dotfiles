-- faster loading?
vim.loader.enable()

-- options
local function set(opts)
    for k,v in pairs(opts) do
        vim.opt[k] = v
    end
end

set({
    number = true,
    relativenumber = true,
    wrap = true,
    linebreak = true,
    clipboard = 'unnamedplus',
    mouse = '', -- change to 'a' to enable mouse
    autoindent = true,
    ignorecase = true,
    smartcase = true, -- ignores casing in search unless searching with casing
    shiftwidth = 4,
    tabstop = 4,
    softtabstop = 4, -- tab in insert mode
    expandtab = true, -- change tab to spaces for consistency in editors
    scrolloff = 10,
    sidescrolloff = 8,
    cursorline = false, -- highlight current line
    splitbelow = true,
    splitright = true,
    showmode = false,
    termguicolors = true, -- beter colors
    signcolumn = "yes",
    undofile = true,
    swapfile = false,
    hlsearch = false,
    shellcmdflag = '-ic', -- will give ! an interactive shell and copies bashrc
})
-- colorscheme
local colorscheme = "shaunsingh/nord.nvim"
vim.g.nord_disable_background = true

-- manager
require "paq" {
    "savq/paq-nvim",
    "stevearc/oil.nvim",
    "savq/paq-nvim",
    "shaunsingh/nord.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
    "saghen/blink.lib",
    { "saghen/blink.cmp", version = "1.*", build = 'cargo build --release' },
    "neovim/nvim-lspconfig",
    "rachartier/tiny-code-action.nvim",
    "norcalli/nvim-colorizer.lua",
    "Omnisharp/omnisharp-vim",
    "nvim-tree/nvim-web-devicons",
    "nvim-lualine/lualine.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
}

-- plugin setup
require("oil").setup()
require("blink.cmp").setup({
    keymap = { preset = "default" },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
})

-- lsp setup
local servers = {
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
            	},
	       },
	    },
    },
    omnisharp = {
        settings = {
            FormattingOptions =  { 
                NewLinesForBracesInControlBlocks = true
            },
        },
    },
    pylsp = {},
    denols = {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { "deno.json", "deno.jsonc", "deno.lock" },
        settings = {
            deno = {
                enable = true,
                lint = true
            },
        },
    },
    roslyn_ls = {},
    clangd = {},
    gopls = {},
}

vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
for server, config in pairs(servers) do
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end


-- diagnostics
vim.diagnostic.config(
    {
        underline = false,
        virtual_text = {
            spacing = 2,
            prefix = "●",
        },
        update_in_insert = false,
        severity_sort = true,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = " ", 
                [vim.diagnostic.severity.WARN] = " ",
                [vim.diagnostic.severity.HINT] = " ",
                [vim.diagnostic.severity.INFO] = " ",
            },
        },
    }
)


-- activate current theme

function returnColorschemeName(inputString)
    local startIdx = inputString:find("/", 1, true)
    local dotIdx = inputString:find(".", startIdx, true)
    
    if startIdx and dotIdx then
        return inputString:sub(startIdx + 1, dotIdx - 1)
    else
        return "default" -- fallback
    end
end

vim.cmd.colorscheme("bark")
--vim.cmd("colorscheme " .. returnColorschemeName(colorscheme))


-- keymaps
-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Defaults
map('n', '<C-w>', ':w<CR>', opts)

map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)


-- Telescope
local builtin = require('telescope.builtin')
map('n', '<leader>ff', builtin.find_files, opts)
map('n', '<leader>fw', builtin.grep_string, opts)
map('n', '<leader>fe', builtin.current_buffer_fuzzy_find, opts)
map('n', 'gd', builtin.lsp_definitions, opts)
map('n', 'gr', builtin.lsp_references, opts)
map('n', 'gi', builtin.lsp_implementations, opts)

-- Oil
map('n', '-', '<cmd>Oil<cr>')


-- Lsp stuff
map('n', 'ld', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)

-- Code Actions
map({ 'n', 'x' }, '<leader>ca', function()
    require('tiny-code-action').code_action() end, opts)

-- LUALINE (END OF CONFIG ) --

-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require('lualine')

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '#202328',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left {
  function()
    return '▊'
  end,
  color = { fg = colors.blue }, -- Sets highlighting of component
  padding = { left = 0, right = 1 }, -- We don't need space before this
}

ins_left {
  -- mode component
  function()
    return ''
  end,
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [''] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red,
    }
    return { fg = mode_color[vim.fn.mode()] }
  end,
  padding = { right = 1 },
}

ins_left {
  -- filesize component
  'filesize',
  cond = conditions.buffer_not_empty,
}

ins_left {
  'filename',
  cond = conditions.buffer_not_empty,
  color = { fg = colors.magenta, gui = 'bold' },
}

ins_left { 'location' }

ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }

ins_left {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    error = { fg = colors.red },
    warn = { fg = colors.yellow },
    info = { fg = colors.cyan },
  },
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {
  function()
    return '%='
  end,
}

ins_left {
  -- Lsp server name .
  function()
    local msg = 'No Active Lsp'
    local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = ' LSP:',
  color = { fg = '#ffffff', gui = 'bold' },
}

-- Add components to right sections
ins_right {
  'o:encoding', -- option component same as &encoding in viml
  fmt = string.upper, -- I'm not sure why it's upper case either ;)
  cond = conditions.hide_in_width,
  color = { fg = colors.green, gui = 'bold' },
}

ins_right {
  'fileformat',
  fmt = string.upper,
  icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
  color = { fg = colors.green, gui = 'bold' },
}

ins_right {
  'branch',
  icon = '',
  color = { fg = colors.violet, gui = 'bold' },
}

ins_right {
  'diff',
  -- Is it me or the symbol for modified us really weird
  symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

ins_right {
  function()
    return '▊'
  end,
  color = { fg = colors.blue },
  padding = { left = 1 },
}

-- Now don't forget to initialize lualine
lualine.setup(config)
