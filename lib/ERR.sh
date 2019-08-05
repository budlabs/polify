#!/bin/env bash

set -E
trap '[ "$?" -ne 77 ] || exit 77' ERR

ERM(){ >&2 echo "$*"; }
ERR(){ >&2 echo "[WARNING]" "$*"; }
ERX(){ >&2 echo "[ERROR]" "$*" && exit 77 ; }
