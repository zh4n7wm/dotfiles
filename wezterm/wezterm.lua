local wezterm = require 'wezterm';

return {
    default_prog = { '/usr/local/bin/fish', '-l'},
    -- font = wezterm.font("JetBrains Mono", {weight="Bold", italic=true}),
    font = wezterm.font("Source Code Pro for Powerline"),
    font_size = 26,
    adjust_window_size_when_changing_font_size = true,
    -- color_scheme = 'builtin_solarized_dark',
    -- color_scheme = 'Fideloper',
    -- color_scheme = 'Neutron',
    -- color_scheme = 'Fideloper',
    -- color_scheme = 'Solarized Dark Higher Contrast',
    color_scheme = 'Solarized (dark) (terminal.sexy)',
    keys = {
        {
            key = 'n',
            mods = 'SHIFT|CTRL',
            action = wezterm.action.ToggleFullScreen,
        },
    },
    selection_word_boundary = ' ={}[]()"\'`,;:',
}
