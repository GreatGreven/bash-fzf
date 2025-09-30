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

set_scroll_margin() {
    printf "\e[H" >&3   # set cursor top left
    printf "\e[0J" >&3  # clear screen
    printf "\e7" >&3    # save cursor pos
    printf "\e[%d;%dr" "0" "$((LINES - 2))" >&3 # set scroll margin top and bottom
    printf "\e8" >&3    # restore saved cursor pos
}

unset_scroll_margin() {
    printf "\e[H" >&3   # set cursor top left
    printf "\e7" >&3    # save cursor pos
    printf "\e[%d;%dr" "0" "$LINES" >&3 # set scroll margin top and bottom
    printf "\e[0J" >&3  # clear screen
    printf "\e8" >&3    # restore saved cursor pos
}

readarray -t original_input
exec 3<> "$TTY" # open file descriptor to terminal so STDOUT can be clean for final output
shopt -s checkwinsize
# this line is to ensure LINES and COLUMNS are set
(:)


set_alternate_screen_buffer
set_scroll_margin
# print divider
printf "\e[%d;%dH" "$((LINES - 1))" "0" >&3
eval printf -- "%0.s=" "{1..$COLUMNS}" >&3
# print in scroll margin
printf "\e[H" >&3
printf "%s\n" "${original_input[@]}" >&3
# print in margin
echo "$LINES" >&3
echo "LINES=$LINES, COLUMNS=$COLUMNS" >&3
printf "\e[%d;%dH" "$LINES" "0" >&3
read -rs -n 1 -u 3 -p "Press any key to continue..." x
echo "$x" >&3
unset_scroll_margin
restore_normal_screen_buffer


