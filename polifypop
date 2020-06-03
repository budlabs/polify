#!/bin/bash

ERX(){ >&2 echo "[ERROR]" "$*" && exit 1 ; }

[[ -z $1 ]] && ERX first argument should be the name of a polify module

msg=$(polify --module "$1" | head -1)
[[ ${msg%% *} = POLIPOP ]] || exit 1
eval "${msg#* }"
