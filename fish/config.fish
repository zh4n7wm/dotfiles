# https://github.com/pure-fish/pure
set pure_symbol_prompt "=>"
set pure_color_virtualenv magenta

# Basic
set -x SHELL /usr/local/bin/fish
set -x TERM screen-256color
set -x EDITOR nvim
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8

# Go
set -x GOPATH $HOME/go
set -x GO111MODULE on

# nodejs
# https://github.com/tj/n
set -x N_PREFIX $HOME/.n

# pipx
test -f ~/.config/fish/completions/pipx.fish || register-python-argcomplete --shell fish pipx >~/.config/fish/completions/pipx.fish

# $PATH
set -e fish_user_paths
set -gx fish_user_paths \
    $GOPATH/bin \
    $HOME/.cargo/bin \
    $HOME/.local/bin \
    $N_PREFIX/bin \
    $HOME/.fzf/bin \
    $HOME/.krew/bin \
    $HOME/Library/Android/sdk/platform-tools \
    /usr/local/opt/coreutils/libexec/gnubin \
    /usr/local/opt/grep/libexec/gnubin \
    /usr/local/opt/findutils/libexec/gnubin \
    /usr/local/opt/gnu-tar/libexec/gnubin \
    /usr/local/opt/gnu-sed/libexec/gnubin \
    /usr/local/opt/gawk/libexec/gnubin \
    /usr/local/opt/ruby/bin \
    /usr/local/opt/llvm/bin \
    /usr/local/sbin \
    /usr/local/bin \
    /usr/sbin \
    /usr/bin \
    /sbin \
    /bin \
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
    bind \ci edit_command_buffer # Ctrl-I
end

# java
# jhome -v 1.7
function jhome
    export JAVA_HOME=$(/usr/libexec/java_home $argv)
    echo "JAVA_HOME:" $JAVA_HOME
    echo "java -version:"
    java -version
end

function genpwd
    set l $argv[1]
    if test "$l" = ""
        set l 20
    end
    tr -dc A-Za-z0-9_ </dev/urandom | head -c $l | xargs
end

# bat https://github.com/sharkdp/bat
set -x BAT_THEME zenburn

# http proxy
set -x http_proxy "http://localhost:7890"
set -x https_proxy $http_proxy
set -x ftp_proxy $http_proxy
set -x rsync_proxy $http_proxy
set -x HTTP_PROXY $http_proxy
set -x HTTPS_PROXY $http_proxy
set -x FTP_PROXY $http_proxy
set -x no_proxy \
    localhost \
    localaddress \
    .localdomain.com \
    10.0.0.0/8 \
    127.0.0.0/8 \
    172.0.0.0/8 \
    192.0.0.0/8 \
    lb.kubesphere.local \
    aliyun.com \
    taobao.org \
    npm.taobao.org \
    registry.npm.taobao.org \
    cnpmjs.org \
    tsinghua.edu.cn \
    docker-cn.com \
    azk8s.cn \
    qiniu.com \
    goproxy.cn \
    rsproxy.cn \
    qingcloud.com \
    mirrors.xjtu.edu.cn \
    sjtug.sjtu.edu.cn \
    mirror.aliyuncs.com \
    c.163.com \
    mirrors.ustc.edu.cn \
    bing.com \
    dict.cn \
    iciba.com \
    youdao.com
set -x NO_PROXY $no_proxy

# Alias
alias vim nvim
alias vi nvim
alias view "nvim -R"

alias ssh "assh wrapper ssh --"
alias g git
alias gst "git status"
alias gc "git commit -ev"
alias sed gsed
# alias cat bat
# alias grep ggrep

# k8s
set -x KUBECONFIG $HOME/.kube/lr.conf
alias k kubectl
