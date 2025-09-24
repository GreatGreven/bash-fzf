#!/usr/bin/env bash
#########################################################################
# Script     : bash-fzf
# Author     : Eric Grevillius
# Date       : 2025-09-24
#########################################################################

set_alternate_screen_buffer() {
    printf "\e[?1049h" >&3
}

restore_normal_screen_buffer() {
    printf "\e[?1049l" >&3
}

readarray -t original_input
exec 3<> "$TTY"
# set_alternate_screen_buffer
printf "%s\n" "${original_input[@]}"
read -rs -n 1 -u 3 -p "Press any key to continue..." x
echo "$x"
# restore_normal_screen_buffer


