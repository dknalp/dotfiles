-- Hyprland 0.57+ Lua keybind overrides
-- Fixes dispatchers broken by hyprlang→Lua migration in 0.57

local Mod = "SUPER + "

-- Unbind first to prevent duplicates on reload
pcall(function() hl.unbind(Mod .. "Q") end)
pcall(function() hl.unbind(Mod .. "D") end)
pcall(function() hl.unbind(Mod .. "SPACE") end)
pcall(function() hl.unbind(Mod .. "Return") end)
pcall(function() hl.unbind(Mod .. "W") end)

-- Close window (killactive was broken in 0.57 hyprlang, handled here)
hl.bind(Mod .. "Q", hl.dsp.window.close())

-- App launcher
hl.bind(Mod .. "D", hl.dsp.exec_cmd("pkill rofi; rofi -show drun -modi drun,filebrowser,run,window"))
hl.bind(Mod .. "SPACE", hl.dsp.exec_cmd("pkill rofi; rofi -show drun -modi drun,filebrowser,run,window"))

-- Terminal
hl.bind(Mod .. "Return", hl.dsp.exec_cmd("kitty"))

-- Brave browser
hl.bind(Mod .. "W", hl.dsp.exec_cmd("brave-browser"))