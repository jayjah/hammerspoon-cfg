-- lock screen shortcut
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'L', function() hs.caffeinate.startScreensaver() end)

hs.grid.setMargins({0, 0})
-- quick jump to important applications
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
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, '4', baseMove(0.5, 0, 0.5, 0.5))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, '5', baseMove(0, 0.5, 0.5, 0.5))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, '6', baseMove(0.5, 0.5, 0.5, 0.5))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'M', hs.grid.maximizeWindow)


-- move current active window to different display
function moveWindowToDisplay(d)
    return function()
        local displays = hs.screen.allScreens()
        local win = hs.window.focusedWindow()
        win:moveToScreen(displays[d], false, true)
    end
end

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, '1', moveWindowToDisplay(1))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, '2', moveWindowToDisplay(2))
hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, '3', moveWindowToDisplay(3))


-- change background image of current active space
function changeBackgroundScreen()
    return function()
        local allImages = {}
        for line in io.popen([[ls /Users/jayjah/Documents/images]]):lines() do
            table.insert(allImages, line)
        end
        local nextImageName = valueFromListAtIndex(allImages, math.random(#allImages))
        for _, screen in pairs(hs.screen.allScreens()) do
            screen:desktopImageURL("file:///Users/jayjah/Documents/images/" .. nextImageName)
        end
    end
end

function valueFromListAtIndex(list, index)
    for i, value in ipairs(list) do
        if (i == index) then return value end
    end
end

hs.hotkey.bind({'ctrl', 'alt', 'cmd'}, 'C', changeBackgroundScreen())

-- move current active window to next left or right space
local hotkey = require "hs.hotkey"
local window = require "hs.window"
local spaces = require "hs.spaces"

function getGoodFocusedWindow(nofull)
    local win = window.focusedWindow()
    if not win or not win:isStandard() then return end
    if nofull and win:isFullScreen() then return end
    return win
end

function flashScreen(screen)
    local flash=hs.canvas.new(screen:fullFrame()):appendElements({
        action = "fill",
        fillColor = { alpha = 0.25, red=1},
        type = "rectangle"})
    flash:show()
    hs.timer.doAfter(.15,function () flash:delete() end)
end

function switchSpace(skip,dir)
    for _ =1,skip do
        hs.eventtap.keyStroke({"ctrl","fn"},dir,0) -- "fn" is a bugfix!
    end
end

function moveWindowOneSpace(dir,switch)
    local win = getGoodFocusedWindow(true)
    if not win then return end
    local screen=win:screen()
    local uuid=screen:getUUID()
    local userSpaces
    for k,v in pairs(spaces.allSpaces()) do
        userSpaces=v
        if k==uuid then break end
    end
    if not userSpaces then return end
    local thisSpace=spaces.windowSpaces(win) -- first space win appears on
    if not thisSpace then return else thisSpace=thisSpace[1] end
    local last=nil
    local skipSpaces=0
    for _, spc in ipairs(userSpaces) do
        if spaces.spaceType(spc)~="user" then -- skippable space
            skipSpaces=skipSpaces+1
        else
            if last and
                    ((dir=="left" and spc==thisSpace) or
                            (dir=="right" and last==thisSpace)) then
                local newSpace=(dir=="left" and last or spc)
                if switch then
                    -- spaces.gotoSpace(newSpace)  -- also possible, invokes MC
                    switchSpace(skipSpaces+1,dir)
                end
                spaces.moveWindowToSpace(win,newSpace)
                return
            end
            last=spc	 -- Haven't found it yet...
            skipSpaces=0
        end
    end
    flashScreen(screen)   -- Shouldn't get here, so no space found
end

hotkey.bind({'ctrl', 'alt'}, "Right",nil,
        function() moveWindowOneSpace("right",true) end)
--hotkey.bind({'ctrl', 'alt', 'cmd'}, "a",nil,
--	    function() moveWindowOneSpace("left",true) end)
hotkey.bind({'ctrl', 'alt'}, "Left",nil,
        function() moveWindowOneSpace("left",true) end)
--hotkey.bind(mashshift, "a",nil,
--	    function() moveWindowOneSpace("left",false) end)

-- Define default Spoons which will be loaded later
if not hspoon_list then
    hspoon_list = {
        "Calendar",
        "WinWin",
    }
end

-- Load those Spoons
for _, v in pairs(hspoon_list) do
    hs.loadSpoon(v)
end

-- resizing window a little part
local winwin = require "WinWin"

hotkey.bind({'shift', 'alt'}, "Left",nil,
        function() winwin:stepResize("left") end)
hotkey.bind({'shift', 'alt'}, "Right",nil,
        function() winwin:stepResize("right") end)
hotkey.bind({'shift', 'alt'}, "Up",nil,
        function() winwin:stepResize("up") end)
hotkey.bind({'shift', 'alt'}, "Down",nil,
        function() winwin:stepResize("down") end)