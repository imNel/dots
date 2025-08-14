local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Color options
config.color_scheme = "nord"
config.colors = {
	tab_bar = {
		background = "#2E3440",
		inactive_tab = {
			bg_color = "#2E3440",
			fg_color = "#616E88",
		},
		active_tab = {
			bg_color = "#D8DEE9",
			fg_color = "#2E3440",
		},
	},
}

config.font = wezterm.font("ZedMono Nerd Font Mono")
config.font_size = 14

config.keys = {
	{
		key = "j",
		mods = "CMD",
		-- sdkey = "F12",
		action = wezterm.action_callback(function(_, pane)
			local tab = pane:tab()
			local panes = tab:panes_with_info()
			if #panes == 1 then
				pane:split({
					direction = "Right",
					size = 0.4,
				})
			elseif not panes[1].is_zoomed then
				panes[1].pane:activate()
				tab:set_zoomed(true)
			elseif panes[1].is_zoomed then
				tab:set_zoomed(false)
				panes[2].pane:activate()
			end
		end),
	},
	{
		key = "g",
		mods = "CMD",
		action = wezterm.action.SpawnCommandInNewTab({
			args = { os.getenv("SHELL"), "-c", "lazygit" },
		}),
	},
}

config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"

return config
