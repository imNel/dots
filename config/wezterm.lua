local is_darwin <const> = wezterm.target_triple:find("darwin") ~= nil

return {
	color_scheme = "Gruvbox Dark (Gogh)",
	font_size = is_darwin and 16.0 or 12.0,
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,
	window_decorations = "RESIZE",
	enable_scroll_bar = false,
	check_for_updates = false,
	window_padding = {
		left = 8,
		right = 8,
		bottom = 8,
		top = 8,
	},
	tab_max_width = 24,
}

