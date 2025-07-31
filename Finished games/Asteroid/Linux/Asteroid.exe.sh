#!/bin/sh
echo -ne '\033c\033]0;Asteroid\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Asteroid.exe.x86_64" "$@"
