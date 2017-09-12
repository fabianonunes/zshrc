
hash setxkbmap 2>/dev/null && setxkbmap -option ctrl:nocaps
bindkey "${key[Up]}" history-beginning-search-backward
bindkey "${key[Down]}" history-beginning-search-forward

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern root)
ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta,bold'

function o {
  xdg-open "$@" &> /dev/null
}

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

alias ak=ak47
alias gri='git ls-files --ignored --exclude-standard | xargs git rm'
alias foda-se='git reset --hard HEAD && git clean -fd'
alias reswap='sudo bash -c "swapoff -a && swapon -a"'

eval "$(fasd --init auto)"
