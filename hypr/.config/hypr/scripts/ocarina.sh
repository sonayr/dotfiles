#!/usr/bin/env bash

# Initial setup
notes=""
max_notes=8

# Note symbols
declare -A note_map
note_map["a"]="A"
note_map["up"]="↑"
note_map["down"]="↓"
note_map["left"]="←"
note_map["right"]="→"

# Function to draw the screen
draw() {
    clear
    local width=$(tput cols)
    local height=$(tput lines)

    # Music Staff
    local staff_y=$((height / 2))
    local staff_width=$((max_notes * 4 + 1))
    local staff_start_x=$(( (width - staff_width) / 2 ))

    for i in {0..4}; do
        tput cup $((staff_y - 2 + i)) $staff_start_x
        printf -- '-%.0s' $(seq 1 $staff_width)
        echo
    done

    # Draw notes
    local current_notes_array=($notes)
    for i in "${!current_notes_array[@]}"; do
        local note=${current_notes_array[$i]}
        local note_x=$((staff_start_x + 2 + (i * 4)))
        local note_y=$staff_y

        if [[ "$note" == "A" ]]; then
            note_y=$staff_y
        elif [[ "$note" == "↑" ]]; then
            note_y=$((staff_y - 1))
        elif [[ "$note" == "↓" ]]; then
            note_y=$((staff_y + 1))
        fi
        
        tput cup $note_y $note_x
        echo "$note"
    done

    # Instructions
    local instructions="Press 'a', arrow keys (or h,j,k,l), or 'b' to quit."
    tput cup $((height - 2)) $(( (width - ${#instructions}) / 2 ))
    echo "$instructions"
}

# Main loop
stty -echo
while true; do
    draw
    read -rsn1 key
    if [[ "$key" == "b" ]]; then
        break
    elif [[ "$key" == "a" ]]; then
        notes="$notes ${note_map["a"]}"
    elif [[ "$key" == "h" ]]; then
        notes="$notes ${note_map["left"]}"
    elif [[ "$key" == "j" ]]; then
        notes="$notes ${note_map["down"]}"
    elif [[ "$key" == "k" ]]; then
        notes="$notes ${note_map["up"]}"
    elif [[ "$key" == "l" ]]; then
        notes="$notes ${note_map["right"]}"
    elif [[ "$key" == $'\e' ]]; then
        read -rsn2 -t 0.1 key
        case "$key" in
            "[A") notes="$notes ${note_map["up"]}" ;;
            "[B") notes="$notes ${note_map["down"]}" ;;
            "[C") notes="$notes ${note_map["right"]}" ;;
            "[D") notes="$notes ${note_map["left"]}" ;;
        esac
    fi

    # Trim notes
    notes_array=($notes)
    if ((${#notes_array[@]} > max_notes)); then
        notes="${notes_array[@]:1}"
    fi
done

# Cleanup
stty echo
clear