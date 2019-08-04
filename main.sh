#!/usr/bin/env bash

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

___source="$(readlink -f "${BASH_SOURCE[0]}")"  #bashbud
___dir="${___source%/*}"                        #bashbud
source "$___dir/init.sh"                        #bashbud
main "${@}"                                     #bashbud
