-- lock screen shortcut
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'L', function() hs.caffeinate.startScreensaver() end)

-- quick jump to important applications
hs.grid.setMargins({0, 0})
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'J', function () hs.application.launchOrFocus("Intellij IDEA Community Edition") end)
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'C', function () hs.application.launchOrFocus("Google Chrome") end)
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'F', function () hs.application.launchOrFocus("Ferdi") end)
-- even though the app is named iTerm2, iterm is the correct name
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'T', function () hs.application.launchOrFocus("iTerm") end)

--[[ function factory that takes the multipliers of screen width
and height to produce the window's x pos, y pos, width, and height ]]
function baseMove(x, y, w, h)
    return function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        -- add max.x so it stays on the same screen, works with my second screen
        f.x = max.w * x + max.x
        f.y = max.h * y
        f.w = max.w * w
        f.h = max.h * h
        win:setFrame(f, 0)
    end
end

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'Left', baseMove(0, 0, 0.5, 1))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'Right', baseMove(0.5, 0, 0.5, 1))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'Down', baseMove(0, 0.5, 1, 0.5))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'Up', baseMove(0, 0, 1, 0.5))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, '1', baseMove(0, 0, 0.5, 0.5))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, '2', baseMove(0.5, 0, 0.5, 0.5))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, '3', baseMove(0, 0.5, 0.5, 0.5))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, '4', baseMove(0.5, 0.5, 0.5, 0.5))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'M', hs.grid.maximizeWindow)