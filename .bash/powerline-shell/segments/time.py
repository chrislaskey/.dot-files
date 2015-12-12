def add_time_segment():
    if powerline.args.shell == 'bash':
        time = ' \\t '
    elif powerline.args.shell == 'zsh':
        time = ' %* '
    else:
        import time
        time = ' %s ' % time.strftime('%H:%M:%S')

    powerline.append(time, Color.TIME_FG, Color.TIME_BG)

add_time_segment()
