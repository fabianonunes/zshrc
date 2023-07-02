set -o noclobber

HISTSIZE=10000000
SAVEHIST=10000000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_BEEP

#hash setxkbmap 2>/dev/null && setxkbmap -option ctrl:nocaps

# no zplug, a variável $key não está inicializada. usar terminfo
# bindkey "${key[Up]}" history-beginning-search-backward
# bindkey "${key[Down]}" history-beginning-search-forward
bindkey "${terminfo[kcuu1]}" history-beginning-search-backward
bindkey "${terminfo[kcud1]}" history-beginning-search-forward

# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern root)
# ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta,bold'

function _o {
  xdg-open "$@" &> /dev/null
}
alias o=_o

function proxyify {
  env http_proxy="" https_proxy="" proxychains "$@"
}

function _set-proxy {
  export http_proxy=$1
  export https_proxy=$1
  export HTTP_PROXY=$1
  export HTTPS_PROXY=$1
}

function set-proxy-local {
  [[ -n "$1" ]] && port=$1 || port="3128"
  _set-proxy "http://localhost:$port"
}

function set-proxy-external {
  _set-proxy "$PROXY_EXTERNAL"
}

function unset-proxy {
  _set-proxy ""
  unset no_proxy
}

function ak47 {
  PORT=${1:-8080}
  PID=$(lsof -i tcp:"$PORT" | grep LISTEN | awk '{ print $2 }')
  [[ -n $PID ]] && (echo "$PID" | xargs kill -9)
}

function add-key {
  sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com \
  --keyserver-options http-proxy="$HTTPS_PROXY" "$1"
}

function lb () {
  $EDITOR ~/Dropbox/logbook/"$(date '+%Y-%m-%d')".md
}

function reswap {
  if [[ -e /dev/zram0 ]]; then
    find /dev -name 'zram*' | sudo parallel swapoff
  fi
  sudo bash -c "swapoff -a && swapon -a"
  [[ -e /dev/zram0 ]] && sudo swapon /dev/zram*
}

alias ak=ak47
alias gri='git ls-files --ignored --exclude-standard | xargs git rm'
alias foda-se='git reset --hard HEAD && git clean -fd'
alias kb='kill -9 %1'
alias k='kubectl'
alias fd=fdfind
alias gpot='git push --tags origin develop master'
alias sudo='sudo '

export GOPATH=$HOME/.go
