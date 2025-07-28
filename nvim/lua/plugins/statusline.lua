local function get_org_wordcount(content)
	content = content:gsub("^%*+%s+", "") -- Asterisks on first line
	content = content:gsub("\n%*+%s+", "\n") -- Asterisks every other line
	content = content:gsub("%- %[[ xX]%] ", "") -- Checkboxes
	content = content:gsub("#%+.-\n", "") -- Org Metadata

	local word_count = 0
	for _ in content:gmatch("%S+") do
		word_count = word_count + 1
	end

	return word_count
end

local function get_speaking_time(wordcount)
	local total_seconds = math.floor(wordcount / 150 * 60)
	local hours = total_seconds >= 3600 and math.floor(total_seconds / 3600) .. "h " or ""
	local minutes = math.floor(total_seconds / 60) % 60 .. "m "
	local seconds = total_seconds % 60 .. "s"
	return hours .. minutes .. seconds
end

local function org_wordcount_component()
	return {
		function()
			local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
			local content = table.concat(lines, "\n")
			local wordcount = get_org_wordcount(content)
			local speakingtime = get_speaking_time(wordcount)

			return "Speaking Time: " .. speakingtime .. " Words: " .. get_org_wordcount(content)
		end,
		cond = function()
			return vim.bo.filetype == "org"
		end,
	}
end

return {
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			local custom_nord = require("lualine.themes.nord")

			-- Change the background of lualine_c section for normal mode
			custom_nord.normal.c.bg = "#2E3440"
			custom_nord.inactive.c.bg = "#2E3440"

			vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

			require("lualine").setup({
				options = {
					theme = custom_nord,
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = {},
					lualine_y = {
						org_wordcount_component(),
					},
					lualine_z = { "filetype" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "filetype" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
}
