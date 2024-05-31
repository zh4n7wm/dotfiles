local wezterm = require 'wezterm';
local act = wezterm.action

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
        -- Clears only the scrollback and leaves the viewport intact.
        -- You won't see a difference in what is on screen, you just won't
        -- be able to scroll back until you've output more stuff on screen.
        -- This is the default behavior.
        {
            key = 'K',
            mods = 'CTRL|SHIFT',
            action = act.ClearScrollback 'ScrollbackOnly',
        },

        -- Clears the scrollback and viewport leaving the prompt line the new first line.
        {
            key = 'K',
            mods = 'CTRL|SHIFT',
            action = act.ClearScrollback 'ScrollbackAndViewport',
        },

        -- Clears the scrollback and viewport, and then sends CTRL-L to ask the
        -- shell to redraw its prompt
        {
            key = 'K',
            mods = 'CTRL|SHIFT',
            action = act.Multiple {
                act.ClearScrollback 'ScrollbackAndViewport',
                act.SendKey { key = 'L', mods = 'CTRL' },
            },
        },
    },
    selection_word_boundary = ' ={}[]()"\'`,;:^$#+',
}
