local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Color options
config.color_scheme = "NvimDark"
config.colors = {
	tab_bar = {
		background = "#14161B",
		inactive_tab = {
			bg_color = "#14161B",
			fg_color = "#C4C6CD",
		},
		active_tab = {
			bg_color = "#C4C6CD",
			fg_color = "#14161B",
		},
	},
}

config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"

return config
