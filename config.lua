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
	{
		"simrat39/rust-tools.nvim",
		config = function()
			require('rust-tools').setup()
		end
	},
}

-- Rust debugger using vscode extension for extra features
-- Update this path
local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb'
local this_os = vim.loop.os_uname().sysname;
-- The path in windows is different
if this_os:find "Windows" then
	codelldb_path = extension_path .. "adapter\\codelldb.exe"
	liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
else
	-- The liblldb extension is .so for linux and .dylib for macOS
	liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
end

local dap = require('dap')
dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = codelldb_path,
		args = { "--port", "${port}" },
	},
}

dap.configurations.rust = {
	{
		name = "Rust debug",
		type = "codelldb",
		request = "launch",
		program = "cargo",
		args = {
			"run",
		},
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		initCommands = function()
			-- Find out where to look for the pretty printer Python module
			local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))

			local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
			local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

			local commands = {}
			local file = io.open(commands_file, 'r')
			if file then
				for line in file:lines() do
					table.insert(commands, line)
				end
				file:close()
			end
			table.insert(commands, 1, script_import)

			return commands
		end,
	}
}

lvim.leader = "space"
-- lvim.colorscheme = "one-monokai-80"
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
-- If your .bashrc equivalent checks for a .nvmrc file, add this before that check

vim.cmd [[
let $PATH = $HOME . '/.nvm/versions/node/v18.12.1/bin:' . $PATH
]]

-----------
-- Keybinds
-----------

-- Buffer navigation
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- Toggle wrapping
lvim.keys.normal_mode["zz"] = ":set wrap! wrap?<CR>"

-- Insert tab character
lvim.keys.insert_mode["<S-Tab>"] = "<C-V><Tab>"

-- insert newline without exiting normal mode
lvim.keys.normal_mode["<Enter>"] = ":call append(line('.'), '')<CR>"
lvim.keys.normal_mode["<M-Enter>"] = ":call append(line('.')-1, '')<CR>"

-- Remove newlines in normal mode
lvim.keys.normal_mode["<BS>"] = "\"_dd"
lvim.keys.normal_mode["<M-BS>"] = "mzk\"_ddg`z"

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

lvim.keys.normal_mode["<Home>"] = "^"
lvim.keys.normal_mode["<End>"] = "$"
lvim.keys.insert_mode["<Home>"] = "<C-o>^"
lvim.keys.insert_mode["<End>"] = "<C-o>$"

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
