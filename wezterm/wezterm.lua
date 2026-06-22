local wezterm = require("wezterm")

local config = wezterm.config_builder()

local is_windows = os.getenv("OS") and os.getenv("OS"):lower():find("windows")
local is_macos = wezterm.target_triple:lower():find("darwin") ~= nil

config.color_scheme = "Sequoia Monochrome"

-- Pull the active scheme's palette so the tab bar matches the content area.
local scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]

-- Derive tab-bar surfaces from the scheme bg so theme swaps just work.
local surface = wezterm.color.parse(scheme.background):lighten(0.08) -- active tab
local hover = wezterm.color.parse(scheme.background):lighten(0.04)   -- hover state

config.window_frame = {
  font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" }),
  -- background of the fancy tab bar (the strip your tabs sit in)
  active_titlebar_bg = scheme.background,
  inactive_titlebar_bg = scheme.background,
}

config.colors = {
  tab_bar = {
    background = scheme.background,
    active_tab = {
      bg_color = surface, -- subtle surface above the bar, derived from scheme bg
      fg_color = scheme.foreground,
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = scheme.background,
      fg_color = scheme.ansi[8] or scheme.foreground,
    },
    inactive_tab_hover = {
      bg_color = hover,
      fg_color = scheme.foreground,
    },
    new_tab = {
      bg_color = scheme.background,
      fg_color = scheme.ansi[8] or scheme.foreground,
    },
    new_tab_hover = {
      bg_color = hover,
      fg_color = scheme.foreground,
    },
  },
}

config.max_fps = 120
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "DemiBold" })
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.inactive_pane_hsb = {
  saturation = 0.0,
  brightness = 0.5,
}

if is_windows then
  config.win32_system_backdrop = "Acrylic"
  config.window_background_opacity = 0.7
  config.window_frame.font_size = 10.0
end

if is_macos then
  config.window_background_opacity = 0.92
  config.macos_window_background_blur = 50
  config.font_size = 15.0
  config.window_frame.font_size = 13.0
end

return config
