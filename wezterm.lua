local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  local defaultDir = "/Users/francistran/Desktop"
  local defaultWorkspace = "default"

  local sandboxDir = "/Users/francistran/Desktop/testing"
  local sandboxWorkspace = "sandbox"

  local defaultTab, defaultPane, defaultWindow = mux.spawn_window(cmd or {
    cwd=defaultDir,
    workspace=defaultWorkspace
  })
  -- defaultPane:send_text 'nvim .wezterm.lua \n'

  -------------- Sandbox Workspace Setup --------------
  local editorSandboxTab, editorSandboxPane, sandboxWindow = mux.spawn_window(cmd or {
    cwd=sandboxDir,
    workspace=sandboxWorkspace
  })
  editorSandboxPane:send_text 'nvim \n'

  local gitSandboxTab, gitSandboxPane, sandboxWindow = sandboxWindow:spawn_tab {}
  gitSandboxPane:send_text 'git status\n'

  mux.set_active_workspace 'default'
end)

-- Updates the name top right of the window if we change workspaces
wezterm.on('update-right-status', function(window, pane)
  local activeWorkspaceName = window:active_workspace()
  local workspaceDisplayName = activeWorkspaceName:sub(1, 1):upper() .. activeWorkspaceName:sub(2)
  window:set_right_status(workspaceDisplayName)
end)

return {
  color_scheme = "carbonfox",
  font_size = 20.0,

  font = wezterm.font_with_fallback({
    {
      family = "JetBrains Mono",
      harfbuzz_features = {"calt=0", "liga=0"},
    },
  }),

-- Background image (uncomment if needed)
--   window_background_image = "/Users/francistran/Desktop/psykos.png",
--   window_background_opacity = 0.5,
-- macos_window_background_blur = 20,

  keys = {
    { key = "n", mods = "SUPER", action = wezterm.action { SendKey = { key = "n", mods = "CTRL" } } },
    { key = "u", mods = "SUPER", action = wezterm.action { SendKey = { key = "u", mods = "CTRL" } } },
    { key = "d", mods = "SUPER", action = wezterm.action { SendKey = { key = "d", mods = "CTRL" } } },
    { key = "j", mods = "SUPER", action = wezterm.action { SendKey = { key = "j", mods = "CTRL" } } },
    { key = "k", mods = "SUPER", action = wezterm.action { SendKey = { key = "k", mods = "CTRL" } } },
    { key = "o", mods = "SUPER", action = wezterm.action { SendKey = { key = "o", mods = "CTRL" } } },
    { key = "r", mods = "SUPER", action = wezterm.action { SendKey = { key = "r", mods = "CTRL" } } },
    { key = "p", mods = "SUPER", action = wezterm.action { SendKey = { key = "p", mods = "CTRL" } } },
    { key = "p", mods = "SUPER", action = wezterm.action { SendKey = { key = "p", mods = "CTRL" } } },

    { key = 'K', mods = 'SUPER', action = act.ClearScrollback 'ScrollbackAndViewport', },
    { key = "l", mods = "SUPER", action = act.Multiple {
      act.SendKey { key = "UpArrow" },
      act.SendKey { key = "Enter" },
    }
  },

  -- { key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },

  -- Switch workspaces
  { key = ';', mods = "SUPER", action = act.SwitchWorkspaceRelative(1) },

  -- Toggle Fullscreen
  { key = 'Enter', mods = "SUPER", action = wezterm.action_callback(function (window, pane)
    -- Work laptop initial width = 1968, height = 1374. Post maximize call: width = 3456, height = 2112
    local windowDimensions = window:get_dimensions()
    local windowIsNotMaximized = windowDimensions.pixel_width < 3000 and windowDimensions.pixel_height < 2000
    if windowIsNotMaximized then
      window:maximize()
    else
      window:restore()
    end
    -- Open wezterm from another terminal to see logs
    -- wezterm.log_info(windowIsNotMaximized)
  end)},
  }
}
