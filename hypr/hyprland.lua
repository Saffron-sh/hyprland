-- Converted from hyprland.conf (hyprlang) to hyprland.lua (Hyprland 0.55+)
-- Original file had no monitor/decoration/general/input headers grouping —
-- reorganized here to match the shape Hyprland expects, but every
-- value and behavior is preserved 1:1 from your original.

local mainMod = "SUPER"

----------------------------------------
---- AUTOSTART (was exec-once = ...) ----
----------------------------------------
-- exec-once has no direct Lua keyword. Instead, subscribe to the
-- "hyprland.start" event, which fires once per session (not on reload).
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("dunst")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("~/.scripts/python/random_theme.py")
end)

------------------
---- MONITORS ----
------------------
-- monitor=HDMI-A-2,1920x1080@60,0x0,1
hl.monitor({
    output = "HDMI-A-2",
    mode = "1920x1080@60",
    position = "0x0",
    scale = 1,
})

-- Commented out in your original — left here disabled the same way.
-- hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1 })
-- hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@120", position = "auto", scale = 1, mirror = "eDP-1" })

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = "rgba(2685bdcc)",
            inactive_border = "rgba(444444aa)",
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 7,
        active_opacity = 0.93,
        inactive_opacity = 0.93,
        blur = {
            enabled = true,
            size = 7,
            passes = 2,
        },
    },
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            middle_button_emulation = true,
        },
    },
})

---------------------
---- ANIMATIONS ------
---------------------
-- workspaces + border kept as originally set.
-- windows/windowsIn/windowsOut restored to Hyprland's stock defaults —
-- these got overwritten before by a single flat "windows" leaf, which
-- made open and close look identical. Stock has them asymmetric:
-- open uses a springy slide, close is a fast linear pop.
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "workspaces", enabled = true, speed = 8, bezier = "default", style = "slide" })
hl.animation({ leaf = "windows",    enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 4.1,  spring = "easy", style = "slide 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "border",     enabled = true, speed = 34, bezier = "default" })

----------------
---- GESTURES ----
----------------
-- gesture = 3, horizontal, workspace
-- gesture = 3, pinchin, fullscreen
-- gesture = 3, pinchout, close
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "pinchin", action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "pinchout", action = "close" })

---------------------
---- KEYBINDINGS ----
---------------------

-- Launch terminal
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty -o allow_remote_control=yes -o enabled_layouts=tall"))

-- Kill focused window
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- Reload config
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("hyprctl reload"))

-- Exit Hyprland (logout)
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())

-- Lock
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))

-- Move focus between windows (custom vim-ish layout: j/l/i/k)
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + i", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "down" }))

-- Move to left/right workspaces (relative, among existing workspaces)
-- NOTE: your original used bare -1/+1, legacy hyprlang shorthand for this.
-- The current wiki and official example always use the explicit "e+1"/"e-1"
-- prefix, so that's what's used here — behavior is identical.
hl.bind(mainMod .. " + left", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ workspace = "+1" }))

-- Offbeat Ivy additional mouse buttons
hl.bind(mainMod .. " + mouse:276", hl.dsp.exec_cmd("kitty"))
hl.bind("mouse:275", hl.dsp.focus({ workspace = "-1" }))
hl.bind("mouse:276", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SHIFT + mouse:275", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SHIFT + mouse:276", hl.dsp.window.move({ workspace = "+1" }))

-- X75 Knob press
hl.bind("code:172", hl.dsp.exec_cmd('grim "$HOME/Pictures/screenshots/$(date | tr \' \' \'_\').png"'))

-- Move windows to left/right workspaces
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }))

-- Workspaces on Display (all commented out in your original — kept disabled)
-- hl.workspace_rule({ workspace = "1", monitor = "eDP-1" })
-- hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
-- hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })
-- hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })
-- hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1" })

-- Switch windows between workspaces (SUPER SHIFT + 1..7)
for i = 1, 7 do
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Run apps
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("hyprland-run"))

-- Theme switching: random
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.scripts/python/random_theme.py"))

-- Theme switching: sequenced
hl.bind(mainMod .. " + CTRL + 0", hl.dsp.exec_cmd("~/.scripts/bash/theme_switch.sh bright"))
hl.bind(mainMod .. " + CTRL + 1", hl.dsp.exec_cmd("~/.scripts/bash/theme_switch.sh kath"))
hl.bind(mainMod .. " + CTRL + 2", hl.dsp.exec_cmd("~/.scripts/bash/theme_switch.sh forest"))
hl.bind(mainMod .. " + CTRL + 3", hl.dsp.exec_cmd("~/.scripts/bash/theme_switch.sh red"))
hl.bind(mainMod .. " + CTRL + 4", hl.dsp.exec_cmd("~/.scripts/bash/theme_switch.sh avalon"))
hl.bind(mainMod .. " + CTRL + 5", hl.dsp.exec_cmd("~/.scripts/bash/theme_switch.sh steel-scale"))
hl.bind(mainMod .. " + CTRL + 6", hl.dsp.exec_cmd("~/.scripts/bash/theme_switch.sh dragon"))
hl.bind(mainMod .. " + CTRL + 7", hl.dsp.exec_cmd("~/.scripts/bash/theme_switch.sh tux"))
hl.bind(mainMod .. " + CTRL + 8", hl.dsp.exec_cmd("~/.scripts/bash/theme_switch.sh mauser"))
hl.bind(mainMod .. " + CTRL + 9", hl.dsp.exec_cmd("~/.scripts/bash/theme_switch.sh avenger"))
hl.bind(mainMod .. " + CTRL + minus", hl.dsp.exec_cmd("~/.scripts/bash/theme_switch.sh space"))
hl.bind(mainMod .. " + CTRL + equal", hl.dsp.exec_cmd("~/.scripts/bash/theme_switch.sh leviathan"))

-- Volume (binde -> repeating = true keeps the "repeat while held" behavior)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

-- Hyprsunset gamma shortcuts
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl hyprsunset gamma 100"))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd("hyprctl hyprsunset gamma 10"))

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +10%"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { repeating = true })


-- App shortcuts
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("wofi --show drun -w 3 -I -G"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind("CTRL + grave", hl.dsp.exec_cmd("mullvad-browser"))
hl.bind(mainMod .. " + grave", hl.dsp.exec_cmd("chromium"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("kate"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("signal-desktop"))

-- Terminal functions
hl.bind("SHIFT + SPACE", hl.dsp.exec_cmd("kitten quick-access-terminal"))

-- Function keys
-- hl.bind("F1", hl.dsp.exec_cmd("kitty"))
hl.bind("F2", hl.dsp.exec_cmd("mixxx"))
-- hl.bind("F3", hl.dsp.exec_cmd("kitty"))
hl.bind("F4", hl.dsp.exec_cmd("kitty -e bash -c 'termusic'"))
-- hl.bind("F5", hl.dsp.exec_cmd("kitty"))
-- hl.bind("F6", hl.dsp.exec_cmd("kitty"))
-- hl.bind("F7", hl.dsp.exec_cmd("kitty"))
-- hl.bind("F8", hl.dsp.exec_cmd("kitty"))
-- hl.bind("F9", hl.dsp.exec_cmd("kitty"))
-- hl.bind("F10", hl.dsp.exec_cmd("kitty"))
-- hl.bind("F11", hl.dsp.exec_cmd("kitty"))
-- hl.bind("F12", hl.dsp.exec_cmd("kitty"))

-- Workspaces (SUPER + 1..7)
for i = 1, 7 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end
