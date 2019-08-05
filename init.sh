#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
polify - version: 2019.08.05.5
updated: 2019-08-05 by budRich
EOB
}


# environment variables
: "${POLIFY_DIR:=/tmp/polify}"


___printhelp(){
  
cat << 'EOB' >&2
polify - Update polybar hookmodules in a safe and smooth way


SYNOPSIS
--------
polify --module|-o TARGET-MODULE [OPTIONS] [MESSAGE]
polify --module|-o TARGET-MODULE [--pid|-p PID] [--foreground|-f COLOR] [--background|-b COLOR] [--leftclick|-l COMMAND] [--rightclick|-r COMMAND] [--middleclick|-m COMMAND] [--scrollup|-u COMMAND] [--scrolldown|-d COMMAND] [--prefix|-e STRING [ [--foreground-prefix|-F COLOR]  [--background-prefix|-B COLOR] [--leftclick-prefix|-L COMMAND] [--rightclick-prefix|-R COMMAND] [--middleclick-prefix|-M COMMAND] [--scrollup-prefix|-U COMMAND] [--scrolldown-prefix|-D COMMAND] ] [--expire-time|-t SECONDS] [--msg|-s MESSAGE] [MESSAGE]
polify --module|-o TARGET-MODULE [--pid|-p PID] --clear|-x
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


--scrollup|-u COMMAND  
COMMAND will get executed when MESSAGE is
scrolled up.


--scrolldown|-d COMMAND  
COMMAND will get executed when MESSAGE is
scrolled down.


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


--scrollup-prefix|-U COMMAND  
COMMAND will get executed when PREFIX is scrolled
up.


--scrolldown-prefix|-D COMMAND  
COMMAND will get executed when PREFIX is scrolled
down.


--expire-time|-t SECONDS  
If set module will get cleared after SECONDS


--msg|-s MESSAGE  
Will get added to the module text file before the
actual message/prefix. Can be used to store
information such as the current state of the
module


--clear|-x  
Clears the module.


--help|-h  
Show help and exit.


--version|-v  
Show version and exit.

EOB
}


for ___f in "${___dir}/lib"/*; do
  source "$___f"
done

declare -A __o
eval set -- "$(getopt --name "polify" \
  --options "o:p:f:b:l:r:m:u:d:e:F:B:L:R:M:U:D:t:s:xhv" \
  --longoptions "module:,pid:,foreground:,background:,leftclick:,rightclick:,middleclick:,scrollup:,scrolldown:,prefix:,foreground-prefix:,background-prefix:,leftclick-prefix:,rightclick-prefix:,middleclick-prefix:,scrollup-prefix:,scrolldown-prefix:,expire-time:,msg:,clear,help,version," \
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
    --scrollup   | -u ) __o[scrollup]="${2:-}" ; shift ;;
    --scrolldown | -d ) __o[scrolldown]="${2:-}" ; shift ;;
    --prefix     | -e ) __o[prefix]="${2:-}" ; shift ;;
    --foreground-prefix | -F ) __o[foreground-prefix]="${2:-}" ; shift ;;
    --background-prefix | -B ) __o[background-prefix]="${2:-}" ; shift ;;
    --leftclick-prefix | -L ) __o[leftclick-prefix]="${2:-}" ; shift ;;
    --rightclick-prefix | -R ) __o[rightclick-prefix]="${2:-}" ; shift ;;
    --middleclick-prefix | -M ) __o[middleclick-prefix]="${2:-}" ; shift ;;
    --scrollup-prefix | -U ) __o[scrollup-prefix]="${2:-}" ; shift ;;
    --scrolldown-prefix | -D ) __o[scrolldown-prefix]="${2:-}" ; shift ;;
    --expire-time | -t ) __o[expire-time]="${2:-}" ; shift ;;
    --msg        | -s ) __o[msg]="${2:-}" ; shift ;;
    --clear      | -x ) __o[clear]=1 ;; 
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





