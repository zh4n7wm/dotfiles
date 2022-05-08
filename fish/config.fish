# https://github.com/pure-fish/pure
set pure_symbol_prompt "=>"
set pure_color_virtualenv "magenta"

# Basic
set -x SHELL /usr/local/bin/fish
set -x TERM screen-256color
set -x EDITOR nvim
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8

# Go
set -x GOPATH $HOME/go
set -x GO111MODULE on

# $PATH
set -e fish_user_paths
set -gx fish_user_paths \
        $GOPATH/bin \
        $HOME/.cargo/bin \
        /usr/local/lib/ruby/gems/3.0.0/bin \
        /usr/local/opt/ruby/bin \
        /Applications/Postgres.app/Contents/Versions/latest/bin/Applications/Postgres.app/Contents/Versions/latest/bin \
        /usr/local/opt/llvm/bin \
        /usr/local/sbin \
        /usr/local/bin \
        /usr/sbin \
        /usr/bin \
        /sbin \
        /bin \
        $HOME/.fzf/bin \
        $fish_user_paths

set -x XDG_CONFIG_HOME $HOME/.config

# https://github.com/junegunn/fzf
set -x FZF_DEFAULT_COMMAND 'fd --type f --exclude .git'

# Rewrite Greeting message
functions -c fish_greeting _old_fish_greeting
function fish_greeting
    _old_fish_greeting
    if type -q fortune and type -q lolcat
        fortune -s | lolcat -t
    end
end

## Rewrite prompt for pyenv (overriding pure-fish/pure)
#functions -c _pure_prompt_virtualenv _old_pure_prompt_virtualenv
#function _pure_prompt_virtualenv
#    if set -q PYENV_VERSION
#        # https://github.com/pure-fish/pure/blob/master/functions/_pure_prompt_virtualenv.fish
#        echo -n -s (set_color magenta) "" (basename "$PYENV_VERSION") "" (set_color normal) ""
#    end
#    if set -q VIRTUAL_ENV
#        echo -n -s (set_color magenta) "" (basename "$VIRTUAL_ENV") "" (set_color normal) ""
#    end
#end
#
#

# vi mode
if status is-interactive
    set -g fish_key_bindings fish_vi_key_bindings
end

function reverse_history_search
  history | fzf --no-sort | read -l command
  if test $command
    commandline -rb $command
  end
end

function fish_user_key_bindings
  bind -M default / reverse_history_search
  # 在编辑器中编辑命令
  bind \ci edit_command_buffer  # Ctrl-I
end

# bat https://github.com/sharkdp/bat
set -x BAT_THEME zenburn

# Alias
alias vim "nvim"
alias vi "nvim"
alias view "nvim -R"

alias ssh "assh wrapper ssh --"
alias g "git"
alias gst "git status"
alias gc "git commit -ev"
alias sed gsed
# alias cat bat
# alias grep ggrep
