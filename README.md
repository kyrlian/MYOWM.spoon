# MYOWM.spoon 

## My Own Windows Mover

A [hammerspoon](https://www.hammerspoon.org/) spoon to snap and move windows with hotkeys, inspired by [rectangle](https://rectangleapp.com/). 

See also [MYOWM-AutoHotkey](https://github.com/kyrlian/MYOWM-AutoHotkey) to use on windows with [AutoHotkey](https://www.autohotkey.com/).

It uses the current position & size of the window to decide how to move/resize it.

For exemple the 'left' move will:
- snap the windows left, keeping the right border in place - hence widening the windows
- if already snapped left, will resize to half screen width
- if already snapped left and less of half screen width, will snap to top and maximize vertically
- if all the above, will move to next screen on the left

## Install

- Get [hammerspoon](https://www.hammerspoon.org/)

- Clone:

```sh
git clone https://github.com/kyrlian/MYOWM.spoon ~/.hammerspoon/Spoons/MYOWM.spoon
```

- Add to `~/.hammerspoon/init.lua`:

```lua
MYOWM = hs.loadSpoon("MYOWM")
MYOWM:bindHotkeys(MYOWM.defaultHotkeys)
--[[
MYOWM:bindHotkeys({
    go_left     = {{"cmd", "alt", "ctrl"}, "left" },
    go_right    = {{"cmd", "alt", "ctrl"}, "right"},
    go_up   = {{"cmd", "alt", "ctrl"}, "up"},
    go_down    = {{"cmd", "alt", "ctrl"}, "down"}, 
    go_full     = {{"cmd", "alt", "ctrl"}, "f"}
})
]]
```