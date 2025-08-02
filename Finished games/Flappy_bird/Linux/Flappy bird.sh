#!/bin/sh
echo -ne '\033c\033]0;Flappy bird\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Flappy bird.x86_64" "$@"
