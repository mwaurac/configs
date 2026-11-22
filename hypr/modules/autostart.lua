-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--

local config = require("modules.vars")

 hl.on("hyprland.start", function () 
   hl.exec_cmd(config.terminal)
   hl.exec_cmd("nm-applet")
   hl.exec_cmd("waybar")
   hl.exec_cmd("hyprpaper")
   hl.exec_cmd("systemctl --user start hyprpolkitagent")
   hl.exec_cmd("mako")
   hl.exec_cmd("wl-paste --watch cliphist store")
   hl.exec_cmd("zen-browser")
   hl.exec_cmd("todoist")
   hl.exec_cmd("hypridle")
 end)
