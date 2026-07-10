-- Hammerspoon config

hs.hotkey.bind({"cmd", "shift"}, "R", function()
  hs.reload()
end)

hs.alert.show("Hammerspoon started")

-- General config

--local modifierKeysForApps = {"cmd", "shift"}
--local modifierKeysForLayouts = {"cmd", "shift", "ctrl"}
local modifierKeysForApps = {"cmd", "ctrl"}
local modifierKeysForLayouts = {"cmd", "shift"}

local apps = {
	cursor = { name = "Code", path = "/Applications/Cursor.app" },
	ghostty = { name = "Ghostty", path = "/Applications/Ghostty.app" },
	wezterm = { name = "WezTerm", path = "/Applications/WezTerm.app" },
	tableplus = { name = "TablePlus", path = "/Applications/TablePlus.app" },
	firefox = { name = "Firefox", path = "/Applications/Firefox.app" },
	firefox_developer_edition = { name = "Firefox", path = "/Applications/Firefox Developer Edition.app" },
	obsidian = { name = "Obsidian", path = "/Applications/Obsidian.app" },
	discord = { name = "Discord", path = "/Applications/Discord.app" },
	slack = { name = "Slack", path = "/Applications/Slack.app" },
	spotify = { name = "Spotify", path = "/Applications/Spotify.app" },
	xcode = { name = "Xcode", path = "/Applications/Xcode.app" },
	zoom = { name = "Zoom", path = "/Applications/zoom.us.app" },
}

local browsers = { apps.firefox, apps.firefox_developer_edition }
local editors = { apps.cursor }
local terminals = { apps.ghostty }
local db_tools = { apps.tableplus }

-- application hotkeys

-- Given an application, open it or focus on one of its windows.
-- If the focused window is on a different screen than the mouse cursor
-- then move the cursor to center of the new window.
--[[ --]]
local function launchOrFocus(app)
	local current_mouse_screen = hs.mouse.getCurrentScreen()

	if app.launchOrFocus then
		app.launchOrFocus()
	else
		hs.application.launchOrFocus(app.path)
	end

	local new_window = hs.window.focusedWindow()

	if current_mouse_screen ~= new_window:screen() then
		local new_mouse_coords = new_window:frame().center
		hs.mouse.absolutePosition(new_mouse_coords)
	end
end

hs.hotkey.bind(modifierKeysForApps, ";", function()
	launchOrFocus(apps.xcode)
end)

hs.hotkey.bind(modifierKeysForApps, "l", function()
	launchOrFocus(apps.cursor)
end)

hs.hotkey.bind(modifierKeysForApps, "k", function()
	launchOrFocus(apps.ghostty)
end)

hs.hotkey.bind(modifierKeysForApps, "j", function()
	-- launchOrFocus(apps.firefox)
	launchOrFocus(apps.firefox_developer_edition)
end)

hs.hotkey.bind(modifierKeysForApps, "i", function()
	launchOrFocus(apps.tableplus)
end)

-- `n` when using ctrl
-- `p` when using cmd
hs.hotkey.bind(modifierKeysForApps, "d", function()
   launchOrFocus(apps.discord)
end)

hs.hotkey.bind(modifierKeysForApps, "n", function()
   launchOrFocus(apps.slack)
end)

hs.hotkey.bind(modifierKeysForApps, "m", function()
	launchOrFocus(apps.spotify)
end)

hs.hotkey.bind(modifierKeysForApps, "o", function()
	launchOrFocus(apps.obsidian)
end)

hs.hotkey.bind(modifierKeysForApps, "z", function()
	launchOrFocus(apps.zoom)
end)

-- Window position management

screen = hs.screen.allScreens()[1]:name()
windowPositions = {}

function maybeSaveOriginalWindowPosition(window)
    local f = window:frame()
    local id = window:id()

    if not windowPositions[id] then
        windowPositions[id] = {
            x = f.x,
            y = f.y,
            w = f.w,
            h = f.h
        }
    end
end

function getOriginalWindowPosition(window)
    local id = window:id()

    return windowPositions[id]
end

hs.hotkey.bind(modifierKeysForLayouts, "Down", function()
    local window = hs.window.focusedWindow()
    local f = window:frame()
    local original = getOriginalWindowPosition(window)

    if original then
        f.x = original.x
        f.y = original.y
        f.w = original.w
        f.h = original.h
        window:setFrame(f, 0)
    end
end)

hs.hotkey.bind(modifierKeysForLayouts, "Up", function()
    local window = hs.window.focusedWindow()
    local f = window:frame()
    local screen = window:screen()
    local max = screen:frame()

    maybeSaveOriginalWindowPosition(window)

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    window:setFrame(f, 0)
end)

hs.hotkey.bind(modifierKeysForLayouts, "Left", function()
    local window = hs.window.focusedWindow()
    local f = window:frame()
    local screen = window:screen()
    local max = screen:frame()

    maybeSaveOriginalWindowPosition(window)

    -- Cycles through the follow widths:
    --   1/2
    --   1/3
    --   2/3

    local width = max.w / 2

    if f.w == (max.w / 2) and f.y == max.y then
      width = max.w / 3
    elseif f.w == (max.w / 3) and f.y == max.y then
      width = (max.w / 3) + (max.w / 3)
    end

    f.x = max.x
    f.y = max.y
    f.w = width
    f.h = max.h
    window:setFrame(f, 0)
end)

hs.hotkey.bind(modifierKeysForLayouts, "Right", function()
    local window = hs.window.focusedWindow()
    local f = window:frame()
    local screen = window:screen()
    local max = screen:frame()

    maybeSaveOriginalWindowPosition(window)

    -- Cycles through the follow widths:
    --   1/2
    --   1/3
    --   2/3

    local width = max.w / 2
    local positionX = max.x + (max.w / 2)

    if f.w == (max.w / 2) and f.y == max.y then
      width = max.w / 3
      positionX = max.x + ((max.w / 3) + (max.w / 3))
    elseif f.w == (max.w / 3) and f.y == max.y then
      width = (max.w / 2) + (max.w / 4)
      positionX = max.x + (max.w / 3)
    end

    f.x = positionX
    f.y = max.y
    f.w = width
    f.h = max.h

    window:setFrame(f, 0)
end)

-- Display sleep

function setCaffeineDisplay(state)
  if state then
    caffeine:setTitle("AWAKE")
    caffeine:setTooltip("Display will not go to sleep")
  else
    caffeine:setTitle("Zz")
    caffeine:setTooltip("Display will go to sleep")
  end
end

function caffeineClicked()
  setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

caffeine = hs.menubar.new()

if caffeine then
  caffeine:setClickCallback(caffeineClicked)
  setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end
