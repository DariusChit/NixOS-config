local config = function()
	local theme = require("lualine.themes.catppuccin")
	theme.normal.c.bg = nil

	require("lualine").setup({
		options = {
			section_separators = { left = "", right = "" },
			component_separators = "|",
			theme = theme,
			globalstatus = true,
		},
		sections = {
			lualine_a = {
				{ "mode", separator = { left = "" }, padding = { right = 1 } },
			},
			lualine_b = {
				{ "filename", padding = { left = 1 } },
			},
			lualine_c = { "branch", "diff", "diagnostics" },
			lualine_x = { { "filetype" } },
			lualine_y = {
				{
					function()
						local lsps = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
						local icon = require("nvim-web-devicons").get_icon_by_filetype(vim.bo.filetype)
						if lsps and #lsps > 0 then
							local names = {}
							for _, lsp in ipairs(lsps) do
								table.insert(names, lsp.name)
							end
							return string.format("%s %s", table.concat(names, ", "), icon or "")
						else
							return icon or ""
						end
					end,
					on_click = function()
						vim.api.nvim_command("LspInfo")
					end,
					color = function()
						local _, color = require("nvim-web-devicons").get_icon_cterm_color_by_filetype(vim.bo.filetype)
						return { fg = color }
					end,
					padding = { right = 1 },
				},
			},
			lualine_z = {
				{ "location", separator = { right = "" }, padding = { left = 1 } },
			},
		},
		extensions = {
			"nvim-tree",
			"lazy",
			"fugitive",
			"fzf",
		},
	})
end

return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	config = config,
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
