#!/bin/sh
echo -ne '\033c\033]0;Connect4\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Connect4.x86_64" "$@"
