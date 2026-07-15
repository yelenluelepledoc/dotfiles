local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- Kun's exact color scheme
config.color_scheme = 'rose-pine-moon'

-- Hack Nerd Font, size 15 — same as the video
config.font = wezterm.font('Hack Nerd Font')
config.font_size = 15

-- Translucent + blurred background (Windows uses Acrylic for the blur)
config.window_background_opacity = 0.92
config.win32_system_backdrop = 'Acrylic'

-- Clean, frameless window; hide the tab bar when there's one tab
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = 'RESIZE'
config.window_padding = { left = 14, right = 14, top = 12, bottom = 8 }

-- Launch into PowerShell 7, not the old shell
config.default_prog = { 'pwsh.exe', '-NoLogo' }

-- Phase 8: tmux-style multiplexer keybinds (WezTerm's built-in multiplexer)
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  { key = '"', mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = '%', mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'c', mods = 'LEADER', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
}

return config
