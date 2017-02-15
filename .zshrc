# load zgen
source "${HOME}/.zgen/zgen.zsh"

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # plugins
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/command-not-found
    zgen load zsh-users/zsh-syntax-highlighting

    # bulk load
    zgen loadall <<EOPLUGINS
        zsh-users/zsh-history-substring-search
EOPLUGINS
    # ^ can't indent this EOPLUGINS

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    zgen oh-my-zsh themes/robbyrussell

    # save all to init script
    zgen save
fi

PROMPT='[%*]%{$fg_bold[green]%} %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}%{$reset_color%}%(?.%{$fg[green]%}.%{$fg[red]%})%B%(!.#.$)%b '

# using peco
#function vig {
#    STR="$1"
#    vim $(grep -n ${STR} **/*.go | grep -v "[0-9]:\s*//" | peco | awk -F ":" '{print "-c "$2" "$1}')
#}
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# history
HIST_STAMPS="yyyy/mm/dd"

# go
export PATH=$PATH:/usr/local/go/bin
export PATH=$HOME/project/bin:$PATH
export GOPATH=$HOME/project

# node
export PATH=$HOME/.nodebrew/current/bin:$PATH
nodebrew use stable
export PATH=$PATH:./node_modules/.bin
export PATH="$HOME/.yarn/bin:$PATH"

# alias
alias gdw="git diff --color-words"
alias gh='cd $(ghq list -p | peco)'
alias glogg='git log --graph --name-status --pretty=format:"%C(red)%h %C(green)%an %Creset%s %C(yellow)%d%Creset"'
alias dstat='dstat -tlamp'

# tmux
#alias tmux="LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/tmux"
if [ `who am i | awk '{print $1}'` != "vagrant" ];then \
  show-current-dir-as-window-name() {
    tmux set-window-option window-status-format " #I: ${PWD:t} " > /dev/null
    tmux set-window-option window-status-current-format " #I: ${PWD:t} " > /dev/null
  }
  show-current-dir-as-window-name
  add-zsh-hook chpwd show-current-dir-as-window-name
fi;

# vim
export EDITOR='vim'

# rust
source $HOME/.cargo/env



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
