def add_root_indicator_segment():
    root_indicators = {
        'bash': ' \\$',
        'zsh': ' %#',
        'bare': ' $',
    }
    bg = Color.CMD_PASSED_BG
    fg = Color.CMD_PASSED_FG
    powerline.append(root_indicators[powerline.args.shell], fg, bg)

add_root_indicator_segment()
