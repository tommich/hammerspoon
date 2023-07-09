-- window
hs.hotkey.bind({"cmd", "ctrl", "alt"}, "l", function()
    local win = hs.window.focusedWindow()
    local screen = win:screen()
    win:moveOneScreenEast()
    local nextScreen = screen:next()
    local center = get_center_of_screen(nextScreen)
    hs.mouse.absolutePosition(center)
    mouseHighlight()
    moving_center = center
    moving_magnitude = big_magnitude
end)

-- window
hs.hotkey.bind({"cmd", "ctrl", "alt"}, "h", function()
    local win = hs.window.focusedWindow()
    local screen = win:screen()
    win:moveOneScreenWest()
    local nextScreen = screen:previous()
    local center = get_center_of_screen(nextScreen)
    hs.mouse.absolutePosition(center)
    mouseHighlight()
    moving_center = center
    moving_magnitude = big_magnitude
end)

-- window
-- resizing window
local fullscreen = function()
    -- size focused window to size of desktop
    local win = hs.window.focusedWindow()
    local new_frame = win:frame()
    local screen = win:screen()
    local screen_frame = screen:frame()

    new_frame.x = screen_frame.x
    new_frame.y = screen_frame.y
    new_frame.w = screen_frame.w
    new_frame.h = screen_frame.h
    win:setFrame(new_frame)
end

-- window
hs.hotkey.bind({"cmd", "ctrl", "alt"}, "k", fullscreen)
hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "up", fullscreen)

-- window
hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "right", function()
    -- size focused window to right half of display
    local win = hs.window.focusedWindow()
    local new_frame = win:frame()
    local screen = win:screen()
    local screen_frame = screen:frame()

    new_frame.x = screen_frame.x + (screen_frame.w / 2)
    new_frame.y = screen_frame.y
    new_frame.w = screen_frame.w / 2
    new_frame.h = screen_frame.h
    win:setFrame(new_frame)
end)

-- window
hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "left", function()
    -- size focused window to left half of display
    local win = hs.window.focusedWindow()
    local new_frame = win:frame()
    local screen = win:screen()
    local screen_frame = screen:frame()

    new_frame.x = screen_frame.x
    new_frame.y = screen_frame.y
    new_frame.w = screen_frame.w / 2
    new_frame.h = screen_frame.h
    win:setFrame(new_frame)
end)

-- window
hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "up", function()
    -- size focused window to top half of display
    local win = hs.window.focusedWindow()
    local new_frame = win:frame()
    local screen = win:screen()
    local screen_frame = screen:frame()

    new_frame.x = screen_frame.x
    new_frame.y = screen_frame.y
    new_frame.w = screen_frame.w
    new_frame.h = screen_frame.h / 2
    win:setFrame(new_frame)
end)

-- window
hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "down", function()
    -- size focused window to bottom half of display
    local win = hs.window.focusedWindow()
    local new_frame = win:frame()
    local screen = win:screen()
    local screen_frame = screen:frame()

    new_frame.x = screen_frame.x
    new_frame.y = screen_frame.y + (screen_frame.h / 2)
    new_frame.w = screen_frame.w
    new_frame.h = screen_frame.h / 2
    win:setFrame(new_frame)
end)