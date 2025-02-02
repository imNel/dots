local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'tokyonight-storm'
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.window_decorations = "RESIZE"
config.window_close_confirmation = 'NeverPrompt'

return config
