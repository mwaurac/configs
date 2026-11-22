local config = require("modules.vars")
---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(config.terminal))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + M",
  hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(config.fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(config.menu))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p 'clipboard: ' | cut -f1 | xargs -I{} cliphist decode {} | wl-copy"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(config.browser))
hl.bind(mainMod .. " + up", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Move focus with mainMod + vim
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "left" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


hl.bind("Print",
  hl.dsp.exec_cmd(
    "f=$HOME/Pictures/Screenshots/ss-$(date +%H-%M-%S).png; grim -g \"$(slurp)\" \"$f\" && wl-copy --type image/png < \"$f\""))

hl.bind(mainMod .. " + Escape", hl.dsp.submap("logout"))
hl.define_submap("logout", function()
  hl.bind("C", function()
    hl.dispatch(hl.dsp.submap("reset"))
    hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
    hl.dispatch(hl.dsp.exec_cmd("hyprctl reload"))
  end)

  hl.bind("E", function()
    hl.dispatch(hl.dsp.submap("reset"))
    hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
    hl.dispatch(hl.dsp.exit())
  end)

  hl.bind("S", function()
    hl.dispatch(hl.dsp.submap("reset"))
    hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
    hl.dispatch(hl.dsp.exec_cmd("systemctl suspend"))
  end)

  hl.bind("R", function()
    hl.dispatch(hl.dsp.submap("reset"))
    hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
    hl.dispatch(hl.dsp.exec_cmd("systemctl reboot"))
  end)

  hl.bind("SHIFT + S", function()
    hl.dispatch(hl.dsp.submap("reset"))
    hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
    hl.dispatch(hl.dsp.exec_cmd("systemctl poweroff -i"))
  end)

  hl.bind("L", function()
    hl.dispatch(hl.dsp.submap("reset"))
    hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
    hl.dispatch(hl.dsp.exec_cmd("hyprlock"))
  end)

  hl.bind("escape", function()
    hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
    hl.dispatch(hl.dsp.submap("reset"))
  end)
end)

hl.on("keybinds.submap", function(name)
  if name == "logout" then
    hl.notification.create({
      text = "c - reload\ne - exit\ns - suspend\nr - reboot\nS - poweroff\nl - lock",
      duration = 3000,
      color = "rgb(34E2E2)",
      font_size = 18,
    })
  end
end)
