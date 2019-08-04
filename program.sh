#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
polify - version: 2019.08
updated: 2019-08-04 by budRich
EOB
}


# environment variables
: "${POLIFY_DEFAULT_MODULE:=polify}"


main(){

  _tmpdir="/tmp/polify"

  _module="${__o[module]:-${POLIFY_DEFAULT_MODULE:-}}"
  [[ -z $_module ]] && ERX "no target module specified"

  _trgfile="$_tmpdir/$_module"

  if ((__o[clear]==1)); then
    clearmodule
  elif ((__o[update]==1)); then
    updatemodule
  elif [[ -z "${msg:=${*-}}" ]]; then
    readfromfile
  else

    _filecontent=""
    [[ -n ${__o[prefix]} ]] \
      && _filecontent+="$(stringbuilder -prefix "${__o[prefix]}")"
    
    _filecontent+="$(stringbuilder "$msg")"
    
    [[ -n ${__o[msg]} ]] \
      && _filecontent="$(printf '%s\n' "${__o[msg]}" "$_filecontent")"

    updatefile "$_filecontent"
    updatemodule

    [[ -n ${__o[expire-time]:-} ]] \
      && timeout "${__o[expire-time]}" &
  fi
}

stringbuilder() {

  local msg p pre suf fg bg a1 a2 a3


  [[ $1 = -prefix ]] && {
    p="$1"
    shift
  }

  msg="$*"

  # https://github.com/jaagr/polybar/wiki/Formatting

  [[ -n ${fg:=${__o[foreground${p}]}} ]] \
    && { pre+="%{F${fg}}" suf+="%{F-}" ;}

  [[ -n ${bg:=${__o[background${p}]}} ]] \
    && { pre+="%{B${bg}}" suf+="%{B-}" ;}

  [[ -n ${a1:=${__o[leftclick${p}]}} ]] \
    && { pre+="%{A1:${a1}:}" suf+="%{A}" ;}

  [[ -n ${a2:=${__o[middlelick${p}]}} ]] \
    && { pre+="%{A2:${a2}:}" suf+="%{A}" ;}

  [[ -n ${a3:=${__o[rightclick${p}]}} ]] \
    && { pre+="%{A3:${a3}:}" suf+="%{A}" ;}

  echo "${pre}${msg}${suf}"

}

timeout() {
  local t="$1"

  if [[ $t =~ [0-9]+ ]]; then
    sleep "$t"
    [[ "$_filecontent" = "$(readfromfile)" ]] && clearmodule
  fi
}

updatefile() {
  local string="${1:-}"

  [[ -f $_trgfile ]] || mkdir -p "${_trgfile%/*}"
  echo "$string" > "$_trgfile"
}

readfromfile() {
  if [[ -f $_trgfile ]]; then
    cat "$_trgfile"
  else
    echo
  fi
}

clearmodule() {
  updatefile
  updatemodule
}

updatemodule() { polybar-msg hook "$_module" 1 > /dev/null 2>&1 ;}

___printhelp(){
  
cat << 'EOB' >&2
polify - The most convenient way to update hookmodules on a polybar


SYNOPSIS
--------
polify [OPTIONS] [MESSAGE]
polify [--module|-o TARGET-MODULE] [--pid|-p PID] [--foreground|-f COLOR] [--background|-b COLOR] [--leftclick|-l COMMAND] [--rightclick|-r COMMAND] [--middleclick|-m COMMAND] [--prefix|-e STRING [ [--foreground-prefix|-F COLOR]  [--background-prefix|-B COLOR] [--leftclick-prefix|-L COMMAND] [--rightclick-prefix|-R COMMAND] [--middleclick-prefix|-M COMMAND] ] [--expire-time|-t SECONDS] [--msg|-s MESSAGE] [MESSAGE]
polify [--module|-o TARGET-MODULE] [--pid|-p PID] --clear|-x
polify [--module|-o TARGET-MODULE] [--pid|-p PID] --update|-U
polify --help|-h
polify --version|-v

OPTIONS
-------

--module|-o TARGET-MODULE  
Name of target module


--pid|-p PID  
If set the specified polybar PID process will be
used.


--foreground|-f COLOR  
Hexadecimal color value for MESSAGE foreground
color.


--background|-b COLOR  
Hexadecimal color value for MESSAGE background
color.


--leftclick|-l COMMAND  
COMMAND will get executed when MESSAGE is
left-clicked


--rightclick|-r COMMAND  
COMMAND will get executed when MESSAGE is
right-clicked


--middleclick|-m COMMAND  
COMMAND will get executed when MESSAGE is
middle-clicked


--prefix|-e STRING  
PREFIX text


--foreground-prefix|-F COLOR  
Hexadecimal color value for PREFIX foreground
color.


--background-prefix|-B COLOR  
Hexadecimal color value for PREFIX background
color.


--leftclick-prefix|-L COMMAND  
COMMAND will get executed when PREFIX is
left-clicked


--rightclick-prefix|-R COMMAND  
COMMAND will get executed when PREFIX is
right-clicked


--middleclick-prefix|-M COMMAND  
COMMAND will get executed when PREFIX is
middle-clicked


--expire-time|-t SECONDS  
If set module will get cleared after SECONDS


--msg|-s MESSAGE  
Will get added to the module text file before the
actual message/prefix. Can be used to store
information such as the current state of the
module


--clear|-x  
Clears the module (both message and prefix) and
the file.

--update|-U  

--help|-h  
Show help and exit.


--version|-v  
Show version and exit.

EOB
}


ERM(){ >&2 echo "$*"; }
ERR(){ >&2 echo "[WARNING]" "$*"; }
ERX(){ >&2 echo "[ERROR]" "$*" && exit 1 ; }

__=""
__stdin=""

read -N1 -t0.01 __  && {
  (( $? <= 128 ))  && {
    IFS= read -rd '' __stdin
    __stdin="$__$__stdin"
  }
}
declare -A __o
eval set -- "$(getopt --name "polify" \
  --options "o:p:f:b:l:r:m:e:F:B:L:R:M:t:s:xUhv" \
  --longoptions "module:,pid:,foreground:,background:,leftclick:,rightclick:,middleclick:,prefix:,foreground-prefix:,background-prefix:,leftclick-prefix:,rightclick-prefix:,middleclick-prefix:,expire-time:,msg:,clear,update,help,version," \
  -- "$@"
)"

while true; do
  case "$1" in
    --module     | -o ) __o[module]="${2:-}" ; shift ;;
    --pid        | -p ) __o[pid]="${2:-}" ; shift ;;
    --foreground | -f ) __o[foreground]="${2:-}" ; shift ;;
    --background | -b ) __o[background]="${2:-}" ; shift ;;
    --leftclick  | -l ) __o[leftclick]="${2:-}" ; shift ;;
    --rightclick | -r ) __o[rightclick]="${2:-}" ; shift ;;
    --middleclick | -m ) __o[middleclick]="${2:-}" ; shift ;;
    --prefix     | -e ) __o[prefix]="${2:-}" ; shift ;;
    --foreground-prefix | -F ) __o[foreground-prefix]="${2:-}" ; shift ;;
    --background-prefix | -B ) __o[background-prefix]="${2:-}" ; shift ;;
    --leftclick-prefix | -L ) __o[leftclick-prefix]="${2:-}" ; shift ;;
    --rightclick-prefix | -R ) __o[rightclick-prefix]="${2:-}" ; shift ;;
    --middleclick-prefix | -M ) __o[middleclick-prefix]="${2:-}" ; shift ;;
    --expire-time | -t ) __o[expire-time]="${2:-}" ; shift ;;
    --msg        | -s ) __o[msg]="${2:-}" ; shift ;;
    --clear      | -x ) __o[clear]=1 ;; 
    --update     | -U ) __o[update]=1 ;; 
    --help       | -h ) __o[help]=1 ;; 
    --version    | -v ) __o[version]=1 ;; 
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

if [[ ${__o[help]:-} = 1 ]]; then
  ___printhelp
  exit
elif [[ ${__o[version]:-} = 1 ]]; then
  ___printversion
  exit
fi

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" 


main "${@:-}"


