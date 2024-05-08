local obj = {}
obj.__index = obj

-- Metadata
obj.name = "MYOWM"
obj.version = "0.1"
obj.author = "kyrlian"
obj.homepage = "https://github.com/kyrlian/MYOWM.spoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- defaultHotkeys keyword for default mapping
--- used when loading with 2nd arg = "default" - hs.spoons.use("MYOWM", "default")
--- https://www.hammerspoon.org/docs/hs.spoons.html#bindHotkeysToSpec
obj.defaultHotkeys = {
    go_left  = { { "ctrl", "alt" }, "left" },
    go_right = { { "ctrl", "alt" }, "right" },
    go_up    = { { "ctrl", "alt" }, "up" },
    go_down  = { { "ctrl", "alt" }, "down" },
    go_full  = { { "ctrl", "alt" }, "space" },
    switch_window_right = { { "ctrl", "alt" }, "tab" },
    switch_window_left = { { "shift", "ctrl", "alt" }, "tab" },
    -- hard_switch_window_right = { { "ctrl", "alt" }, "tab" },
    -- hard_switch_window_left = { { "shift", "ctrl", "alt" }, "tab" },
}

--- moving
--- https://www.hammerspoon.org/docs/hs.window.html
--- left ----
function obj:go_left()
    local win = hs.window.focusedWindow()
    local winframe = win:frame()
    local screen = win:screen()
    local screenframe = screen:frame()
    print("go_left - Screen: " .. screen:name() .. " x:" .. screenframe.x .. ", w:" .. screenframe.w)
    if winframe.x > screenframe.x then         -- snap left
        local keepx2 = winframe.x2             -- keep right side position
        print("snap left - winframe.x:" .. winframe.x .. " to " .. screenframe.x)
        winframe.x = screenframe.x             -- snap left
        print("keep x2 - winframe.x2:" .. winframe.x2 .. " at " .. keepx2)
        winframe.x2 = keepx2                   -- extend width by reclaimed space
        win:setFrame(winframe)
    elseif winframe.w > screenframe.w / 2 then -- resize to half w
        print("resize left - winframe.w:" .. winframe.w .. " to " .. screenframe.w / 2)
        winframe.w = screenframe.w / 2         -- halve the window
        win:setFrame(winframe)
    elseif winframe.h < screenframe.h then     -- if already at 0, maximize vertically
        print("maximize right - winframe.h:" .. winframe.h .. " to " .. screenframe.h)
        winframe.h = screenframe.h             -- maximize height
        winframe.y = screenframe.y             -- snap top
        win:setFrame(winframe)
    else                                       -- if already maxed, move to next screen
        print("Move West")
        win:moveOneScreenWest()
    end
end

--- right ----
function obj:go_right()
    local win = hs.window.focusedWindow()
    local winframe = win:frame()
    local screen = win:screen()
    local screenframe = screen:frame()
    print("go_right - Screen: " .. screen:name() .. " x:" .. screenframe.x .. ", w:" .. screenframe.w)
    if winframe.x2 < screenframe.x2 then
        print("snap right - winframe.x2:" .. winframe.x2 .. " to " .. screenframe.x2)
        winframe.x2 = screenframe.x2           -- snap right
        win:setFrame(winframe)
    elseif winframe.w > screenframe.w / 2 then -- resize to half w
        print("resize right - winframe.w:" .. winframe.w .. " to " .. screenframe.w / 2)
        winframe.x = screenframe.w / 2 -- TODO  + screenframe.x ??
        winframe.w = screenframe.w / 2     -- halve the window
        win:setFrame(winframe)
    elseif winframe.h < screenframe.h then -- if already at 0, maximize vertically
        print("maximize right - winframe.h:" .. winframe.h .. " to " .. screenframe.h)
        winframe.h = screenframe.h         -- maximize height
        winframe.y = screenframe.y         -- snap top
        win:setFrame(winframe)
    else                                   -- if already maxed, move to next screen
        print("Move East")
        win:moveOneScreenEast()
    end
end

--- up
function obj:go_up()
    local win = hs.window.focusedWindow()
    local winframe = win:frame()
    local screen = win:screen()
    local screenframe = screen:frame()
    print("go_up - Screen: " .. screen:name() .. " y:" .. screenframe.y .. ", h:" .. screenframe.h)
    if winframe.y > screenframe.y then         -- snap up
        local keepy2 = winframe.y2             -- keep bottom side position
        print("snap top - winframe.y:" .. winframe.y .. " to " .. screenframe.y)
        winframe.y = screenframe.y             -- snap top
        print("keep y2 - winframe.y2:" .. winframe.y2 .. " at " .. keepy2)
        winframe.y2 = keepy2                   -- extend width by reclaimed space
        win:setFrame(winframe)
    elseif winframe.h > screenframe.h / 2 then -- resize to half h
        print("resize up - winframe.h:" .. winframe.h .. " to " .. screenframe.h / 2)
        winframe.h = screenframe.h / 2         -- halve the window
        win:setFrame(winframe)
    elseif winframe.w < screenframe.w then     -- if already at 0, maximize horizontally
        print("maximize up - winframe.w:" .. winframe.w .. " to " .. screenframe.w)
        winframe.w = screenframe.w             -- maximize width
        winframe.x = screenframe.x             -- snap left
        win:setFrame(winframe)
    else                                       -- if already maxed, move to next screen
        print("Move North")
        win:moveOneScreenNorth()               -- move north
    end
end

--- down
function obj:go_down()
    local win = hs.window.focusedWindow()
    local winframe = win:frame()
    local screen = win:screen()
    local screenframe = screen:frame()
    print("go_down - Screen: " .. screen:name() .. " y:" .. screenframe.y .. ", h:" .. screenframe.h)
    if winframe.y2 < screenframe.y2 - 1 then
        print("snap down - winframe.y2:" .. winframe.y2 .. " to " .. screenframe.y2)
        winframe.y2 = screenframe.y2           -- snap down
        win:setFrame(winframe)
    elseif winframe.y < screenframe.h / 2 then -- resize to half h (+20 for dock)
        -- Note : the dock at the bottom messes up win.h, to I'm snapping to bottom with y2 again
        print("resize down - winframe.y:" .. winframe.y .. " to " .. screenframe.h / 2)
        winframe.y = screenframe.h / 2     -- move top to mid screen
        winframe.y2 = screenframe.y2       -- snap down (h/2 doesnt work because of dock)
        win:setFrame(winframe)
    elseif winframe.w < screenframe.w then -- if already at 0, maximize horizontally
        print("maximize down - winframe.w:" .. winframe.w .. " to " .. screenframe.w)
        winframe.w = screenframe.w         -- maximize width
        winframe.x = screenframe.x         -- snap left
        win:setFrame(winframe)
    else                                   -- if already maxed, move to next screen
        print("Move South")
        win:moveOneScreenSouth()
    end
end

--- center / maximize / zoom = full screen
-- https://www.hammerspoon.org/docs/hs.window.html#centerOnScreen
-- https://www.hammerspoon.org/docs/hs.window.html#maximize
-- https://www.hammerspoon.org/docs/hs.window.html#toggleZoom
-- https://www.hammerspoon.org/docs/hs.window.html#toggleFullScreen
function obj:go_full()
    local win = hs.window.focusedWindow()
    local winframe = win:frame()
    local screen = win:screen()
    local screenframe = screen:frame()
    local wincenterx = winframe.x + winframe.w / 2
    local screenceterx = screenframe.x + screenframe.w / 2
    print("go_full - wincenterx: " .. wincenterx .. ", screenceterx: " .. screenceterx)
    if wincenterx < screenceterx - 1 or wincenterx > screenceterx + 1 then
        print("Center")
        win:centerOnScreen() -- center
    elseif winframe.w < screenframe.w * .9 or winframe.h < screenframe.h * .9 then
        print("Maximize")
        win:maximize() -- maximize
    else
        print("Full Screen")
        win:toggleFullScreen() -- toggle full
    end
end

--- Cascade
-- https://www.hammerspoon.org/docs/hs.window.html#orderedWindows
function obj:cascade()
    local wins = hs.window.orderedWindows() -- ordered front to back
    -- TODO
end

--- Switch between windows by focusing on the next window
-- https://www.hammerspoon.org/docs/hs.window.switcher.html
-- set up your windowfilter
-- switcher = hs.window.switcher.new() -- default windowfilter: only visible windows, all Spaces
-- switcher_browsers = hs.window.switcher.new{'Safari','Google Chrome'} -- specialized switcher for your dozens of browser windows :)
function obj:switch_window(direction)
    local switcher_space = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}) -- include minimized/hidden windows, current Space only
    if direction == "right" then
        switcher_space:next() 
    else
        switcher_space:previous() 
    end
end

---- or manually:
-- https://www.hammerspoon.org/docs/hs.window.html#allWindows
-- https://www.hammerspoon.org/docs/hs.window.html#visibleWindows
-- https://www.hammerspoon.org/docs/hs.window.html#focus
-- https://www.hammerspoon.org/docs/hs.window.html#tabCount
-- https://www.hammerspoon.org/docs/hs.window.html#focusTab
function obj:hard_switch_window(direction)
    local wins = hs.window.visibleWindows()
    local focused = hs.window.focusedWindow()
    local shift = 1
    if direction == "left" then
        shift = -1
    end
    for index, win in ipairs(wins) do 
        if win == focused then
            local targetid = index + shift
            if targetid > #wins then -- lua index are 1 - len
                targetid = 1
            elseif targetid == 0 then
                targetid = #wins
            end
            local tofocus = wins[targetid]
            tofocus:focus()
            break
        end
    end
end

---bind userdefined hotkeys to actions
function obj:bindHotkeys(mapping)
    local spec = {
        go_left = function() self:go_left() end,
        go_right = function() self:go_right() end,
        go_up = function() self:go_up() end,
        go_down = function() self:go_down() end,
        go_full = function() self:go_full() end,
        switch_window_right = function() self:switch_window("right") end,
        switch_window_left = function() self:switch_window("left") end,
        hard_switch_window_right = function() self:hard_switch_window("right") end,
        hard_switch_window_left = function() self:hard_switch_window("left") end,
    }
    hs.spoons.bindHotkeysToSpec(spec, mapping)
    return self
end

return obj
