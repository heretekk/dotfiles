: "zgen" && {
  source "${HOME}/.zgen/zgen.zsh"
  if ! zgen saved; then
    echo "Creating a zgen save..."

    zgen oh-my-zsh
    zgen oh-my-zsh plugins/git

    zgen load aws/aws-cli bin/aws_zsh_completer.sh
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-completions
    zgen load Tarrasch/zsh-autoenv
    zgen load lukechilds/zsh-better-npm-completion
    zgen load docker/cli contrib/completion/zsh/_docker
    zgen load docker/compose contrib/completion/zsh/_docker-compose

    zgen save
  fi
  #autoload -Uz compinit && compinit -i
}

: "env" && {
  # export PROMPT='[%*]%{$fg_bold[green]%} %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}%{$reset_color%}%(?.%{$fg[green]%}.%{$fg[red]%})%B%(!.#.$)%b '
  export PROMPT='[%*]%{$fg_bold[green]%} %{$fg[cyan]%}%c %{$reset_color%}%(?.%{$fg[green]%}.%{$fg[red]%})%B%(!.#.$)%b '
  export HIST_STAMPS="yyyy/mm/dd"
  export EDITOR='vim'
  export HISTSIZE=5000000
  export MANPAGER="col -b -x|vim -"
  # go
  export PATH=$PATH:/usr/local/go/bin
  export PATH=$HOME/go/bin:$PATH
  export PATH=$HOME/project/bin:$PATH
  export GOPATH=$HOME/go:$HOME/project
  # anyenv and node
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
  export PATH=$PATH:./node_modules/.bin
  # rust
  [ -f ~/.cargo/env ] && source ~/.cargo/env
  # fzf
  export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
  # export FZF_DEFAULT_COMMAND='rg ""'
  export FZF_DEFAULT_OPTS="--reverse --height ${FZF_TMUX_HEIGHT:-80%} --select-1 --exit-0"
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  # awscli
  [ -f /usr/local/bin/aws_zsh_completer.sh ] && source /usr/local/bin/aws_zsh_completer.sh
  # other path
  export PATH="$HOME/.cargo/bin:$PATH"
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
  export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
  export PATH=$HOME/.rbenv/shims:$PATH

}

: "alias" && {
  alias history='fc -il 1' # for HIST_STAMPS in oh-my-zsh
  alias rm='rm -i'
  alias gdw="git diff --color-words"
  alias gdww="git diff --word-diff-regex=$'[^\x80-\xbf][\x80-\xbf]*' --word-diff=color"
  alias gh='cd $(ghq list -p | peco)'
  alias glogg='git log --graph --name-status --pretty=format:"%C(red)%h %C(green)%an %Creset%s %C(yellow)%d%Creset"'
  alias glogo='git log --oneline --pretty=format:"%C(red)%h %C(green)%an %Creset%s %C(yellow)%d%Creset"'
  alias dstat='dstat -tlamp'
  alias rg='rg -S'
  alias grebase='git rebase -i $(git log --date=short --pretty="format:%C(yellow)%h %C(green)%cd %C(blue)%ae %C(red)%d %C(reset)%s" |fzy| cut -d" " -f1)'
  alias gbc="~/dotfiles/bin/git-checkout-remote-branch"
  alias l="exa -lha"
  alias lt="exa -lhT"
  alias nswitch="source ~/.switch-proxy"
  alias tsync="tmux set-window-option synchronize-panes"
  alias batd="bat -l diff"
  alias bats="bat -l sh"
  # k8s
  alias k="kubectl"
  alias kg="kubectl get"
  alias kgp="kubectl get pods"
  alias ka="kubectl apply -f"
  alias kd="kubectl describe"
  alias krm="kubectl delete"
  alias klo="kubectl logs -f"
  alias kex="kubectl exec -i -t"
  alias kns="kubens"
  alias kctx="kubectx"

  alias py="python3"
  alias vi="vim"
  alias vimf='vim $(fzf)'
}

: "completions for k8s" && {

  # kubectl
  if (which kubectl > /dev/null); then
    function kubectl() {
      if ! type __start_kubectl >/dev/null 2>&1; then
          source <(command kubectl completion zsh)
      fi
      command kubectl "$@"
    }
  fi

  # kops
  if (which kops > /dev/null); then
    function kops() {
      if ! type __start_kops >/dev/null 2>&1; then
          source <(command kops completion zsh)
      fi
      command kops "$@"
    }
  fi

  # helm
  if (which helm > /dev/null); then
    function helm() {
      if ! type __start_helm >/dev/null 2>&1; then
          source <(command helm completion zsh)
      fi
      command helm "$@"
    }
  fi
}


: "iab" && {
  setopt extended_glob

  typeset -A abbreviations
  abbreviations=(
      "vimfx"    "fzy | xargs vim"
  )

  magic-abbrev-expand() {
      local MATCH
      LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
      LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
      zle self-insert

  }

  no-magic-abbrev-expand() {
      LBUFFER+=' '

  }

  zle -N magic-abbrev-expand
  zle -N no-magic-abbrev-expand
  bindkey " " magic-abbrev-expand
  bindkey "^x " no-magic-abbrev-expand
}

: "powered_cd" && {
  function chpwd() {
    powered_cd_add_log
  }
  function powered_cd_add_log() {
    local i=0
    cat ~/.powered_cd.log | while read line; do
    (( i++ ))
    if [ i = 30 ]; then
      sed -i -e "30,30d" ~/.powered_cd.log
    elif [ "$line" = "$PWD" ]; then
      sed -i -e "${i},${i}d" ~/.powered_cd.log
    fi
  done
  echo "$PWD" >> ~/.powered_cd.log
  }
  function powered_cd() {
    if (which tac > /dev/null); then
      tac="tac"
    else
      tac="tail -r"
    fi
    if [ $# = 0 ]; then
      local dir=$(eval $tac ~/.powered_cd.log | fzf)
      if [ "$dir" = "" ]; then
        return 1
      elif [ -d "$dir" ]; then
        cd "$dir"
      else
        local res=$(grep -v -E "^${dir}" ~/.powered_cd.log)
        echo $res > ~/.powered_cd.log
        echo "powerd_cd: deleted old path: ${dir}"
      fi
    elif [ $# = 1 ]; then
      cd $1
    else
      echo "powered_cd: too many arguments"
    fi
  }
  _powered_cd() {
    _files -/
  }
  compdef _powered_cd powered_cd
  [ -e ~/.powered_cd.log ] || touch ~/.powered_cd.log
  alias c="powered_cd"
}

: "peco snippet" && {
  function peco-select-snippet() {
    BUFFER=$(cat ~/.snippet | peco)
    CURSOR=$#BUFFER
    zle -R -c
  }
  zle -N peco-select-snippet
  bindkey '^x^r' peco-select-snippet
}

: "dstat" && {
  alias dstat-full="dstat -Tclmdrn" # full
  alias dstat-memory="dstat -Tclm"    # memory
  alias dstat-cpu="dstat -Tclr"    # cpu
  alias dstat-network="dstat -Tclnd"   # network
  alias dstat-diskio="dstat -Tcldr"   # diskI/O
}

: "peco history" && {
  function peco-select-history() {
      # historyを番号なし、逆順、最初から表示。
      # 順番を保持して重複を削除。
      # カーソルの左側の文字列をクエリにしてpecoを起動
      # \nを改行に変換
      #BUFFER="$(\history -nr 1 | awk '!a[$0]++' | peco --query "$LBUFFER" | sed 's/\\n/\n/')"
      #CURSOR=$#BUFFER # カーソルを文末に移動
      #zle -R -c       # refresh
      emulate -L zsh
      local delimiter=$'\0; \0' newline=$'\n'
      BUFFER=${"$(print -rl ${history//$newline/$delimiter} | peco --query "$LBUFFER")"//$delimiter/$newline}
      CURSOR=$#BUFFER
      zle -Rc
      zle reset-prompt
  }
  zle     -N   peco-select-history
  bindkey '^r' peco-select-history
}

# <not use>
: "fzf history" && {
  # function fzf-history-widget() {
  #   local selected num
  #   setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  #   selected=( $(fc -rl 1 |
  #     FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  #   local ret=$?
  #   if [ -n "$selected" ]; then
  #     num=$selected[1]
  #     if [ -n "$num" ]; then
  #       zle vi-fetch-history -n $num
  #     fi
  #   fi
  #   zle redisplay
  #   typeset -f zle-line-init >/dev/null && zle zle-line-init
  #   return $ret
  # }
  # zle     -N   fzf-history-widget
  # bindkey '^t' fzf-history-widget
}

: "tmux refresh" && {
  function precmd() {
    if [ ! -z $TMUX ]; then
      tmux refresh-client -S
    fi
  }
}

: "Switch ENV by OSTYPE" && {
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Linux
    #
    if [[ "$USERNAME" == "vagrant" ]]; then
      # Ubuntu1404 in Vagrant
      source ~/dotfiles/.zshrc.ubuntu1404.vagrant;
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    #
    export HOMEBREW_CASK_OPTS="--appdir=/Applications";
  elif [[ "$OSTYPE" == "cygwin" ]]; then
    # POSIX compatibility layer and Linux environment emulation for Windows
    #
  elif [[ "$OSTYPE" == "msys" ]]; then
    # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    #
  elif [[ "$OSTYPE" == "win32" ]]; then
    # I'm not sure this can happen.
    #
  elif [[ "$OSTYPE" == "freebsd"* ]]; then
    # ...
    #
  else
    # Unknown.
    #
  fi
}

: "private source" && {
  if [ -e ~/.zshrc.private ]; then
    source ~/.zshrc.private
  fi
}

: "zprof" && {
  if (which zprof > /dev/null) ;then
    zprof | less
  fi
}

#export PATH="$HOME/.yarn/bin:$PATH"
