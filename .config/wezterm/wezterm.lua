local wezterm = require("wezterm")

wezterm.on("gui-startup", function(cmd)
   local mode = os.getenv("LAUNCH_PROJECT")

    -- Example of how to launch a specific project:
    --
    --     LAUNCH_PROJECT=lego wezterm start --always-new-process
    --
   if mode == "example" then
	local _, first_pane, window = wezterm.mux.spawn_window {}
	local _, second_pane, _ = window:spawn_tab {}

	first_pane:send_text "cd ~/code/example\nvim\n"
	second_pane:send_text "cd ~/code/example\ndocker-compose up -d\nsource .env\niex -S mix phx.server\n"

	window:gui_window():maximize()
   elseif mode == "nova" then
	local _, first_pane, window = wezterm.mux.spawn_window {}
	local _, second_pane, _ = window:spawn_tab {}
	local _, third_pane, _ = window:spawn_tab {}
	local _, fourth_pane, _ = window:spawn_tab {}
	local _, fifth_pane, _ = window:spawn_tab {}
	local _, sixth_pane, _ = window:spawn_tab {}
	local _, seventh_pane, _ = window:spawn_tab {}

	first_pane:send_text "cd ~/code/ws-common\nset -a && source env/dev.env && set +a\nnvim\n"
	second_pane:send_text "cd ~/code/ws-common/apps/nova\nset -a && source env/dev.env && set +a\n"
	third_pane:send_text "cd ~/code/ws-common/apps/nova\nset -a && source env/dev.env && set +a\npg_ctl start\ndocker-compose --profile dependent-services up -d\n"
	fourth_pane:send_text "cd ~/code/ws-common/apps/nova\nset -a && source env/dev.env && set +a\niex -S mix phx.server\n"
	fifth_pane:send_text "cd ~/code/ws-common\nyarn start:firebase-emulator\n"
	sixth_pane:send_text "cd ~/code/ws-common\nyarn serve:auth-api\n"
	seventh_pane:send_text "cd ~/code/moxit-wonderschool-accounts\nyarn dev\n"
  -- Command to start PostgreSQL from `asdf`:
  -- /Users/chrislaskey/.asdf/installs/postgres/14.19/bin/pg_ctl -D /Users/chrislaskey/.asdf/installs/postgres/14.19/data -l logfile start

	window:gui_window():maximize()

   elseif mode == "lego" then
	local _, first_pane, window = wezterm.mux.spawn_window {}
	local _, second_pane, _ = window:spawn_tab {}
	local _, third_pane, _ = window:spawn_tab {}
	local _, fourth_pane, _ = window:spawn_tab {}
	local _, fifth_pane, _ = window:spawn_tab {}
	local _, sixth_pane, _ = window:spawn_tab {}
	local _, seventh_pane, _ = window:spawn_tab {}

	first_pane:send_text "cd ~/code/lego\nset -a && source envs/dev.env && source .env && set +a\nnvim"
	second_pane:send_text "cd ~/code/lego\nset -a && source envs/dev.env && source .env && set +a\n"
	third_pane:send_text "cd ~/code/lego\nset -a && source envs/dev.env && source .env && set +a\ncd apps/lego\nUSE_ESBUILD=true iex -S mix phx.server\n"
	fourth_pane:send_text "cd ~/code/lego\nset -a && source envs/dev.env && source .env && set +a\ngit checkout 110ada8 -- docker-compose.yaml && docker-compose up -d && git checkout origin/master -- docker-compose.yaml\n"
	fifth_pane:send_text "cd ~/code/lego\nset -a && source envs/dev.env && source .env && set +a\ncd apps/lego\nyarn --cwd assets run build.watch\n"
	sixth_pane:send_text "cd ~/code/lego\nset -a && source envs/dev.env && source .env && set +a\ncd ../moxit-wonderschool-web\nyarn dev\n"
	seventh_pane:send_text "cd ~/code/lego\nset -a && source envs/dev.env && source .env && set +a\ncd ../moxit-wonderschool-accounts\nyarn dev\n"

	window:gui_window():maximize()
   else
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
   end
end)

local config = wezterm.config_builder()

config.scrollback_lines = 5000
config.audible_bell = "Disabled"

-- Styling

config.term = "xterm-256color"

config.font = wezterm.font("Monaco Nerd Font Mono")
config.font = wezterm.font("Monaco Nerd Font")
config.font = wezterm.font("Monaco")
config.font_size = 16

--Option: Transparent windows
--config.window_background_opacity = 0.95
--config.macos_window_background_blur = 10

--Option: Color schemes
--config.color_scheme = 'onedarkpro_onedark_vivid'
--config.color_scheme = 'Everforest Dark (Hard)'
--config.color_scheme = 'tokyonight_night'

---

local direction_keys = {
    h = "Left",
    j = "Down",
    k = "Up",
    l = "Right",
}

local function split_nav(key)
    return {
        key = key,
        mods = "CTRL|SHIFT",
        action = wezterm.action_callback(function(win, pane)
            if pane:Get_users_vars().IS_NVIM == "true" then
                -- pass the keys through to vim/nvim
                win:perform_action({
                    SendKey = { key = key, mods = "CTRL" },
                }, pane)
            else
                win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
            end
        end),
    }
end

config.window_decorations = "RESIZE"

config.window_padding = {
    top = 10,
    bottom = 10,
    left = 10,
    right = 10,
}

config.leader = {
    key = "f",
    mods = "CTRL",
    timeout_milliseconds = 5000
}

config.keys = {
    {
        key = "\\",
        mods = "LEADER",
        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "|",
        mods = "LEADER",
        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "-",
        mods = "LEADER",
        action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "_",
        mods = "LEADER",
        action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    split_nav("h"),
    split_nav("j"),
    split_nav("k"),
    split_nav("l"),
    {
        key = "h",
        mods = "CTRL|SHIFT",
        action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
    },
    {
        key = "l",
        mods = "CTRL|SHIFT",
        action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
    },
    {
        key = "j",
        mods = "CTRL|SHIFT",
        action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
    },
    {
        key = "k",
        mods = "CTRL|SHIFT",
        action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
    },
    {
        key = "m",
        mods = "LEADER",
        action = wezterm.action.TogglePaneZoomState,
    },
    {
        key = "Escape",
        mods = "LEADER",
        action = wezterm.action_callback(function (window, pane)
            window:perform_action(wezterm.action.ActivateCopyMode, pane)
            window:perform_action(wezterm.action.CopyMode 'ClearPattern', pane)
        end),
    },
    {
        key = "c",
        mods = "LEADER",
        action = wezterm.action.SpawnTab("CurrentPaneDomain"),
    },
    {
        key = "p",
        mods = "LEADER",
        action = wezterm.action.ActivateTabRelative(-1),
    },
    {
        key = "n",
        mods = "LEADER",
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        key = "k",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection("Up")
    },
    {
        key = "j",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection("Down")
    },
    {
        key = "h",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection("Left")
    },
    {
        key = "l",
        mods = "LEADER",
        action = wezterm.action.ActivatePaneDirection("Right")
    },
    {
      key = '}',
      mods = 'LEADER',
      action = wezterm.action.PaneSelect {
        mode = 'SwapWithActiveKeepFocus'
      },
    },
    {
      key = 's',
      mods = 'LEADER',
      action = wezterm.action.PaneSelect {
        mode = 'SwapWithActiveKeepFocus'
      },
    },
    {
        key = "?",
        mods = "LEADER",
        action = wezterm.action.Search { CaseInSensitiveString = '' },
    },
    {
        key = "1",
        mods = "LEADER",
        action = wezterm.action.ActivateTab(0),
    },
    {
        key = "2",
        mods = "LEADER",
        action = wezterm.action.ActivateTab(1),
    },
    {
        key = "3",
        mods = "LEADER",
        action = wezterm.action.ActivateTab(2),
    },
    {
        key = "4",
        mods = "LEADER",
        action = wezterm.action.ActivateTab(3),
    },
    {
        key = "5",
        mods = "LEADER",
        action = wezterm.action.ActivateTab(4),
    },
    {
        key = "6",
        mods = "LEADER",
        action = wezterm.action.ActivateTab(5),
    },
    {
        key = "7",
        mods = "LEADER",
        action = wezterm.action.ActivateTab(6),
    },
    {
        key = "8",
        mods = "LEADER",
        action = wezterm.action.ActivateTab(7),
    },
    {
        key = "9",
        mods = "LEADER",
        action = wezterm.action.ActivateTab(8),
    },
    {
        key = "l",
        mods = "LEADER",
        action = wezterm.action_callback(function (window, pane)
                local _, first_pane, window = wezterm.mux.spawn_window {}
                local _, second_pane, _ = window:spawn_tab {}
                local _, third_pane, _ = window:spawn_tab {}

                first_pane:send_text "vim\n"
                second_pane:send_text "echo 'hello'\n"
        end)
    },
}

local copy_mode = nil

if wezterm.gui then
  copy_mode = wezterm.gui.default_key_tables().copy_mode

  table.insert(
    copy_mode,
    { key = 'Backspace', mods = 'NONE', action = wezterm.action.CopyMode 'MoveLeft' }
  )

  table.insert(
    copy_mode,
    { key = "k", mods = "CTRL", action = wezterm.action.CopyMode 'PriorMatch' }
  )

  table.insert(
    copy_mode,
    { key = "j", mods = "CTRL", action = wezterm.action.CopyMode 'NextMatch' }
  )
end

config.key_tables = {
  copy_mode = copy_mode
}

return config
