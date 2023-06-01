lvim.plugins = {
    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            require("null-ls").setup()
        end,
    },
    {
        "MunifTanjim/prettier.nvim",
        config = function()
            require("prettier").setup({
                bin = 'prettierd',
                filetypes = {
                    "css",
                    "graphql",
                    "html",
                    "javascript",
                    "javascriptreact",
                    "json",
                    "less",
                    "markdown",
                    "typescript",
                    "typescriptreact",
                    "yaml",
                },
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-ts-autotag").setup({
                -- optional config
            })
        end,
    },
}

lvim.leader = "space"
lvim.colorscheme = "one-monokai-80"
lvim.format_on_save = true
lvim.log.level = "info"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
-- File browser
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
-- Language parser
lvim.builtin.treesitter.auto_install = true
lvim.builtin.treesitter.autotag = true
lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex" }
-- Git visualizations
lvim.builtin.gitsigns.opts.signcolumn = true;
lvim.builtin.gitsigns.opts.numhl = true;
lvim.builtin.gitsigns.opts.current_line_blame = true;
lvim.builtin.gitsigns.opts.signs.add.text = "+"

vim.opt.relativenumber = true

-- Indentation
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = false
vim.opt.listchars:append({ tab = " - ", multispace = ".", leadmultispace = " " })
vim.opt.list = true

-- Soft wrapping
-- TODO: Add toggle keymap
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        command = "prettier",
        -- extra_args = { "--print-width", "100" },
        filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "json",
        },
    },
}

-- Make plugins use a newer version of node.
-- Necessary if working with older node projects.
-- To make the integrated terminal use the default nvm version, add the following to your .bashrc (or equivalent):
-- `[ "$NVIM_APPNAME" = 'lvim' ] && nvm use default --silent`
vim.cmd [[
let $PATH = $HOME . '/.nvm/versions/node/v18.12.1/bin:' . $PATH
]]

-----------
-- Keybinds
-----------

-- Buffer navigation
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- Insert tab character
lvim.keys.insert_mode["<S-Tab>"] = "<C-V><Tab>"

-- Cursor/file navigation
lvim.keys.normal_mode["<S-Up>"] = "10k"
lvim.keys.normal_mode["<S-Down>"] = "10j"
lvim.keys.visual_mode["<S-Up>"] = "10k"
lvim.keys.visual_mode["<S-Down>"] = "10j"
lvim.keys.insert_mode["<S-Up>"] = "<C-o>10k"
lvim.keys.insert_mode["<S-Down>"] = "<C-o>10j"
lvim.keys.normal_mode["<S-PageUp>"] = "25k"
lvim.keys.normal_mode["<S-PageDown>"] = "25j"
lvim.keys.visual_mode["<S-PageUp>"] = "25k"
lvim.keys.visual_mode["<S-PageDown>"] = "25j"
lvim.keys.normal_mode["<C-PageUp>"] = "25<C-y>"
lvim.keys.normal_mode["<C-PageDown>"] = "25<C-e>"

-- Fast git review
lvim.keys.normal_mode["<M-Up>"] =
"<Cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<CR><Cmd>Gitsigns preview_hunk_inline<CR>"
lvim.keys.normal_mode["<M-.>"] =
"<Cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<CR><Cmd>Gitsigns preview_hunk_inline<CR>"
lvim.keys.normal_mode["<M-Down>"] =
"<Cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<CR><Cmd>Gitsigns preview_hunk_inline<CR>"
lvim.keys.normal_mode["<M-/>"] =
"<Cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<CR><Cmd>Gitsigns preview_hunk_inline<CR>"
lvim.keys.normal_mode["<M-Right>"] = "<Cmd>Gitsigns preview_hunk_inline<CR>"
lvim.keys.normal_mode["<M-Left>"] = "<Cmd>lua require 'gitsigns'.stage_hunk()<CR>"
lvim.keys.normal_mode["<M-b>"] = "<Cmd>lua require 'gitsigns'.stage_buffer()<CR>"
lvim.keys.normal_mode["<M-u>"] = "<Cmd>lua require 'gitsigns'.undo_stage_hunk()<CR>"
lvim.keys.normal_mode["<M-q>"] = "<Cmd>Telescope git_status<CR>"
