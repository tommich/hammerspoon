local get_center_of_screen = function(screen)
    local rect = screen:fullFrame()
    local center = hs.geometry.rectMidPoint(rect)
    return center
end

local get_center_of_mouse_screen = function()
    local screen = hs.mouse.getCurrentScreen()
    return get_center_of_screen(screen)
end

local big_magnitude = 2/6
local moving_center = get_center_of_mouse_screen()
local moving_magnitude = big_magnitude

local move_mouse_to_screen = function(screen)
    local center = get_center_of_screen(screen)
    hs.mouse.absolutePosition(center)
    mouseHighlight()
    moving_center = center
    moving_magnitude = big_magnitude
end

local move_mouse_next_screen = function()
    local screen = hs.mouse.getCurrentScreen()
    local nextScreen = screen:next()
    move_mouse_to_screen(nextScreen)
end

local move_mouse_previous_screen = function()
    local screen = hs.mouse.getCurrentScreen()
    local previousScreen = screen:previous()
    move_mouse_to_screen(previousScreen)
end

local move_mouse_to_center = function()
    local center = get_center_of_mouse_screen()
    hs.mouse.absolutePosition(center)
    mouseHighlight()
    moving_center = center
    moving_magnitude = big_magnitude

    local screen = hs.mouse.getCurrentScreen()
    local frame = screen:frame()
    local margined_frame = {x = frame.x + 25, y = frame.y + 40, w = frame.w - 50, h = frame.h - 80}
    jumpGuidesHighlight(margined_frame.w * moving_magnitude, margined_frame.h * moving_magnitude)
end

local move_mouse_relative_to_point = function(point, direction, magnitude)
    local screen = hs.mouse.getCurrentScreen()
    local frame = screen:frame()
    local margined_frame = {x = frame.x + 25, y = frame.y + 40, w = frame.w - 50, h = frame.h - 80}

    --local not_framed_point = {x = point.x + direction.horizontal * frame.w * magnitude, y = point.y + direction.vertical * frame.h * magnitude}
    local framed_point = {x = point.x + direction.horizontal * margined_frame.w * magnitude, y = point.y + direction.vertical * margined_frame.h * magnitude}

    new_point = not_framed_point
    new_point = framed_point

    hs.mouse.absolutePosition(new_point)
    mouseHighlight()
    moving_center = new_point
    moving_magnitude = magnitude/2
    jumpGuidesHighlight(margined_frame.w * moving_magnitude, margined_frame.h * moving_magnitude)
end


local direction_left = {horizontal = -1, vertical = 0}
local direction_right = {horizontal = 1, vertical = 0}

local direction_up_left = {horizontal = -1, vertical = -1}
local direction_up_right = {horizontal = 1, vertical = -1}
local direction_up = {horizontal = 0, vertical = -1}

local direction_down = {horizontal = 0, vertical = 1}
local direction_down_left = {horizontal = -1, vertical = 1}
local direction_down_right = {horizontal = 1, vertical = 1}

local direction_zero = {horizontal = 0, vertical = 0}


-- Find my mouse pointer
local mouseCircle = nil
local mouseCircleTimer = nil

function mouseHighlight()
    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.absolutePosition()
    -- Prepare a big red circle around the mouse pointer
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    -- Set a timer to delete the circle after x seconds
    mouseCircleTimer = hs.timer.doAfter(0.2, clearHighlight)
end

function clearHighlight()
    mouseCircle:delete()
    mouseCircle = nil
end

local guides = nil
local guidesTimer = nil


function jumpGuidesHighlight(horizontalDistance, verticalDistance)
    -- Delete an existing highlight if it exists
    if guides then
        clearGuidesHighlight()
        if guidesTimer then
            guidesTimer:stop()
        end
    end
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.absolutePosition()

    guides = {}

    distance = {horizontal = horizontalDistance, vertical = verticalDistance}

    guides.left = drawSmallRedCircleRelativeToPoint(mousepoint, direction_left, distance)
    guides.right = drawSmallRedCircleRelativeToPoint(mousepoint, direction_right, distance)
    guides.up_left = drawSmallRedCircleRelativeToPoint(mousepoint, direction_up_left, distance)
    guides.up_right = drawSmallRedCircleRelativeToPoint(mousepoint, direction_up_right, distance)
    guides.up = drawSmallRedCircleRelativeToPoint(mousepoint, direction_up, distance)
    guides.down = drawSmallRedCircleRelativeToPoint(mousepoint, direction_down, distance)
    guides.down_left = drawSmallRedCircleRelativeToPoint(mousepoint, direction_down_left, distance)
    guides.down_right = drawSmallRedCircleRelativeToPoint(mousepoint, direction_down_right, distance)

    guidesTimer = hs.timer.doAfter(1.0, clearGuidesHighlight)
end

function drawSmallRedCircleRelativeToPoint(point, direction, distance)
    circle = hs.drawing.circle(hs.geometry.rect(point.x - 3 + distance.horizontal * direction.horizontal, point.y - 3 + distance.vertical * direction.vertical, 6, 6))
    local redColor = { ["red"]=1, ["blue"]=0, ["green"]=0, ["alpha"]=1}
    circle:setStrokeColor(redColor)
    circle:setFill(true)
    circle:setFillColor(redColor)
    circle:show()
    return circle
end

function clearGuidesHighlight()
    guides.left:delete()
    guides.right:delete()
    guides.up_left:delete()
    guides.up_right:delete()
    guides.up:delete()
    guides.down:delete()
    guides.down_left:delete()
    guides.down_right:delete()
    guides = nil
end

--KEY BINDINGS
hs.hotkey.bind({"ctrl", "alt", "shift"}, 'right', move_mouse_next_screen)
hs.hotkey.bind({"ctrl", "alt", "shift"}, 'left', move_mouse_previous_screen)
hs.hotkey.bind({"ctrl", "alt", "shift", 'command'}, 'u', function() move_mouse_relative_to_point(moving_center, direction_up_left, moving_magnitude) end)
hs.hotkey.bind({"ctrl", "alt", "shift", 'command'}, 'i', function() move_mouse_relative_to_point(moving_center, direction_up, moving_magnitude) end)
hs.hotkey.bind({"ctrl", "alt", "shift", 'command'}, 'o', function() move_mouse_relative_to_point(moving_center, direction_up_right, moving_magnitude) end)
hs.hotkey.bind({"ctrl", "alt", "shift", 'command'}, 'j', function() move_mouse_relative_to_point(moving_center, direction_left, moving_magnitude) end)
hs.hotkey.bind({"ctrl", "alt", "shift", 'command'}, 'k', function() move_mouse_to_center() end)
hs.hotkey.bind({"ctrl", "alt", "shift", 'command'}, 'l', function() move_mouse_relative_to_point(moving_center, direction_right, moving_magnitude) end)
hs.hotkey.bind({"ctrl", "alt", "shift", 'command'}, 'm', function() move_mouse_relative_to_point(moving_center, direction_down_left, moving_magnitude) end)
hs.hotkey.bind({"ctrl", "alt", "shift", 'command'}, '[', function() move_mouse_relative_to_point(moving_center, direction_down, moving_magnitude) end)
hs.hotkey.bind({"ctrl", "alt", "shift", 'command'}, 'v', function() move_mouse_relative_to_point(moving_center, direction_down_right, moving_magnitude) end)
hs.hotkey.bind({"ctrl", "alt", "shift", 'command'}, ']', function() move_mouse_relative_to_point(moving_center, direction_down_right, moving_magnitude) end)
--KEY BINDINGS


