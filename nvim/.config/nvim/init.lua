-- TODO: (dont forget to add ts)
-- yank highlighting
-- saving cursor place and going back to it after reopening file

-- [options] ------------------------------------------------------------------
local o = vim.opt

-- colorscheme
vim.cmd.colorscheme("bark")

-- ui
o.number = true
o.relativenumber = true
o.cursorline = false
o.signcolumn = "yes"
o.termguicolors = true
o.showmode = false

-- layout
o.wrap = true
o.linebreak = true
o.breakindent = true
o.scrolloff = 10
o.sidescrolloff = 8
o.splitbelow = true
o.splitright = true

-- input
o.mouse = ""
o.clipboard = "unnamedplus"
o.timeoutlen = 300
o.updatetime = 250

-- search
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true

-- indentation
o.autoindent = true
o.smartindent = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.expandtab = true

-- files
o.undofile = true
o.swapfile = false

-- shell
o.shellcmdflag = "-ic"
-- keybinds


-- [keymaps] ------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- general
map('n', '<C-s>', ':w<CR>', opts)
map('n', '<C-c>', ':q<CR>', opts)
map('n', '<C-w>', ':wq<CR>', opts)

-- window split nav
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)

-- telescope
local builtin = require("telescope.builtin")
map('n', '<leader>ff', builtin.find_files, opts)
map('n', '<leader>fw', builtin.live_grep, opts)
map('n', '<leader>fe', builtin.current_buffer_fuzzy_find, opts)

map('n', 'gd', builtin.lsp_definitions, opts)
map('n', 'gr', builtin.lsp_references, opts)
map('n', 'gi', builtin.lsp_implementations, opts)

-- oil
map('n', '-', '<cmd>Oil --float .<cr>')

-- diagnostics
map('n', '<leader>dt', '<cmd>TinyInlineDiag toggle<cr>', { desc = "Toggle diagnostics" })

-- [plugins] ------------------------------------------------------------------
local sources = { github = "https://github.com/", codeberg = "https://codeberg.org/", }

vim.pack.add({
  sources["github"] .. "savq/paq-nvim",
  sources["github"] .. "nvim-mini/mini.pairs",
  sources["github"] .. "stevearc/oil.nvim",
  sources["github"] .. "nvim-treesitter/nvim-treesitter",
  { src = sources["github"] .. "saghen/blink.cmp",
    version = vim.version.range("^1") },
  sources["github"] .. "nvim-telescope/telescope.nvim",
  sources["github"] .. "rachartier/tiny-inline-diagnostic.nvim",

})

-- configs / setups
require("oil").setup({
    default_file_explorer = true,
    columns = {
        "icon",
        "size",
    },
    skip_confirm_for_simple_edits = true,
    watch_for_changes = true, -- reload oil when fs changes
    show_hidden = false, -- toggle with <C-h>
    keymaps = {
        ["<C-h>"] = { "actions.toggle_hidden", mode = 'n' },
    },
    constraint_cursor = "editable",
    float = {
        max_width = 0.5,
        max_height = 0.6,
        border = "rounded",
        win_options = {
            winblend = 5
        },
    },
    natural_order = "fast",
})


require("blink.cmp").setup({
    keymap = { preset = "default" },
    appearance = {
        nerd_font_variant = "mono"
    },
    fuzzy = {
        implementation = "prefer_rust"
    }
})

require("mini.pairs").setup({})
require("tiny-inline-diagnostic").setup({
    preset = "simple",
	transparent_bg = true,
	transparent_cursorline = true,

    options = {
        multilines = {
            enabled = true,
            always_show = true,
            severity = { vim.diagnostic.severity.ERROR },
	    	softwrap = 20,
        },
    },
})

-- lsp
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
    omnisharp = {},
    pylsp = {},
    denols = {},
    clangd = {},
    gopls = {},
}

vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
for server, config in pairs(servers) do
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end

-- [imports] ------------------------------------------------------------------
-- require("statusline").setup()
