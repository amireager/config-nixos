-- Snacks provides fast workflow tools: picker, explorer, notifications, input, scroll, bigfile, and UI helpers.
local ok, snacks = pcall(require, "snacks")
if not ok then
	return
end

snacks.setup({
	bigfile = { enabled = true },
	quickfile = { enabled = true },
	dashboard = { enabled = false },
	input = { enabled = true },
	notifier = { enabled = true, timeout = 2500 },
	picker = {
		enabled = true,
		sources = {
			files = { hidden = true, ignored = false },
			grep = { hidden = true, ignored = false },
		},
	},
	explorer = { enabled = true },
	indent = { enabled = true },
	scope = { enabled = true },
	scroll = { enabled = true, animate = { duration = { step = 12, total = 120 } } },
	statuscolumn = { enabled = true },
	words = { enabled = true },
})

local map = vim.keymap.set

-- Top-level fast actions.
map("n", "<leader><space>", function()
	snacks.picker.smart()
end, { desc = "Smart find" })
map("n", "<leader>,", function()
	snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>/", function()
	snacks.picker.grep()
end, { desc = "Grep" })
map("n", "<leader>:", function()
	snacks.picker.command_history()
end, { desc = "Command history" })
map("n", "<leader>n", function()
	snacks.picker.notifications()
end, { desc = "Notification history" })

-- Explorer and external file manager.
map("n", "<leader>ee", function()
	snacks.explorer()
end, { desc = "Open Snacks explorer" })
map("n", "<leader>ef", function()
	snacks.explorer({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Explorer at current file" })
map("n", "<leader>ey", function()
	vim.fn.system("tmux split-window -h -l 35% 'yazi " .. vim.fn.shellescape(vim.fn.getcwd()) .. "'")
end, { desc = "Open yazi in tmux" })

-- Find.
map("n", "<leader>ff", function()
	snacks.picker.files()
end, { desc = "Find files" })
map("n", "<leader>fg", function()
	snacks.picker.git_files()
end, { desc = "Find git files" })
map("n", "<leader>fr", function()
	snacks.picker.recent()
end, { desc = "Recent files" })
map("n", "<leader>fb", function()
	snacks.picker.buffers()
end, { desc = "Find buffers" })
map("n", "<leader>fh", function()
	snacks.picker.help()
end, { desc = "Find help" })
map("n", "<leader>fk", function()
	snacks.picker.keymaps()
end, { desc = "Find keymaps" })
map("n", "<leader>fc", function()
	snacks.picker.commands()
end, { desc = "Find commands" })
map("n", "<leader>fp", function()
	snacks.picker.projects()
end, { desc = "Find projects" })

-- Search.
map("n", "<leader>fs", function()
	snacks.picker.lsp_symbols()
end, { desc = "Document symbols" })
map("n", "<leader>fS", function()
	snacks.picker.lsp_workspace_symbols()
end, { desc = "Workspace symbols" })
map("n", "<leader>fw", function()
	snacks.picker.grep_word()
end, { desc = "Find word under cursor" })
map("v", "<leader>fw", function()
	snacks.picker.grep_word()
end, { desc = "Find selected text" })
map("n", "<leader>fd", function()
	snacks.picker.diagnostics_buffer()
end, { desc = "Buffer diagnostics" })
map("n", "<leader>fD", function()
	snacks.picker.diagnostics()
end, { desc = "Workspace diagnostics" })

-- Git pickers.
map("n", "<leader>gb", function()
	snacks.picker.git_branches()
end, { desc = "Git branches" })
map("n", "<leader>gl", function()
	snacks.picker.git_log()
end, { desc = "Git log" })
map("n", "<leader>gL", function()
	snacks.picker.git_log_line()
end, { desc = "Git log line" })
map("n", "<leader>gf", function()
	snacks.picker.git_log_file()
end, { desc = "Git log file" })
map("n", "<leader>gS", function()
	snacks.picker.git_status()
end, { desc = "Git status picker" })
map("n", "<leader>gd", function()
	snacks.picker.git_diff()
end, { desc = "Git diff picker" })

-- UI toggles.
map("n", "<leader>un", function()
	snacks.notifier.hide()
end, { desc = "Dismiss notifications" })
map("n", "<leader>ui", function()
	snacks.toggle.indent():toggle()
end, { desc = "Toggle indent guides" })
map("n", "<leader>us", function()
	snacks.toggle.scroll():toggle()
end, { desc = "Toggle smooth scroll" })
map("n", "<leader>uw", function()
	snacks.toggle.words():toggle()
end, { desc = "Toggle word highlight" })
