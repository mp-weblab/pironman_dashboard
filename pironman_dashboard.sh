#!/bin/bash
# Pironman 5 Terminal Dashboard — version finale stable
# CPU, RAM, Température, IP, Ventilo (style btop avec blocs ⣿)
# Version: 1.0.0
# Author: mp-weblab.com
# Author URI: https://mp-weblab.com
# License: GPLv3
# License URI: https://www.gnu.org/licenses/gpl-3.0.html
#  Note de l'auteur :
# Ce plugin est distribué gratuitement dans un esprit de partage.
# Merci de ne pas le vendre ou monétiser sous une forme quelconque.
# Tout contributeur peut inscrire son nom dans ce code ici :
# Contributors : --- your-name-here ---

# Couleurs
RED='\033[0;31m'
YELLOW='\033[0;93m'
GREEN='\033[0;92m'
CYAN='\033[0;96m'
MAGENTA='\033[0;95m'
NC='\033[0m'
BLINK='\033[5m'

BAR_LEN=60       # longueur des barres
SLEEP_INTERVAL=1

# Cache le curseur et restaure proprement à l'arrêt
tput civis
trap "tput cnorm; clear; exit" SIGINT SIGTERM

# --- Génère une barre colorée proportionnelle ---
make_bar() {
    local percent=$1 len=$2
    local fill=$((percent * len / 100))
    local empty=$((len - fill))
    local bar=""
    for ((j=1;j<=fill;j++)); do
        if ((percent>80)); then COLOR=$RED
        elif ((percent>50)); then COLOR=$YELLOW
        else COLOR=$GREEN
        fi
        bar+="${COLOR}⣿${NC}"
    done
    for ((j=1;j<=empty;j++)); do bar+=" "; done
    echo -e "$bar"
}

# --- Calcule l’usage CPU par cœur ---
get_cpu_usage() {
    CPU_USAGES=()
    CORE_COUNT=$(nproc)
    PREV=($(grep '^cpu[0-9]' /proc/stat))
    sleep 0.3
    NOW=($(grep '^cpu[0-9]' /proc/stat))

    for ((i=0; i<CORE_COUNT; i++)); do
        idx=$((i*11))
        PREV_TOTAL=0
        NOW_TOTAL=0
        for j in {1..10}; do
            PREV_TOTAL=$((PREV_TOTAL + PREV[idx+j]))
            NOW_TOTAL=$((NOW_TOTAL + NOW[idx+j]))
        done
        PREV_IDLE=${PREV[idx+4]}
        NOW_IDLE=${NOW[idx+4]}
        DIFF_TOTAL=$((NOW_TOTAL - PREV_TOTAL))
        DIFF_IDLE=$((NOW_IDLE - PREV_IDLE))
        if ((DIFF_TOTAL == 0)); then
            USAGE=0
        else
            USAGE=$(( (100 * (DIFF_TOTAL - DIFF_IDLE)) / DIFF_TOTAL ))
        fi
        CPU_USAGES+=("$USAGE")
    done
}

# --- Boucle principale ---
while true; do
    tput cup 0 0

    # --- IP & Ventilo ---
    IP=$(hostname -I 2>/dev/null | awk '{print $1}')
    [[ -z "$IP" ]] && IP="(no IP)"
    if systemctl is-active --quiet pironman5; then
        FAN_STATUS="${CYAN}ON${NC}"
    else
        FAN_STATUS="${RED}OFF${NC}"
    fi

    # --- Température CPU ---
    RAWTEMP=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
    TEMP_C=$(awk -v t="$RAWTEMP" 'BEGIN { printf "%.1f", t/1000 }')
    if (( $(echo "$TEMP_C > 70" | bc -l 2>/dev/null) )); then TEMP_COLOR="${RED}${BLINK}"
    elif (( $(echo "$TEMP_C > 60" | bc -l 2>/dev/null) )); then TEMP_COLOR=$RED
    elif (( $(echo "$TEMP_C > 45" | bc -l 2>/dev/null) )); then TEMP_COLOR=$YELLOW
    else TEMP_COLOR=$GREEN; fi

    # --- RAM ---
    RAM_USED=$(free | awk '/^Mem:/ { printf "%.0f", $3/$2 * 100 }')

    # --- Header (largeur fixe à 70 caractères pour l’alignement parfait) ---
    HEADER_WIDTH=70
    LINE=$(printf '─%.0s' $(seq 1 $HEADER_WIDTH))
    echo -e "${CYAN}╭${LINE}╮${NC}"
    printf "${CYAN}│%-${HEADER_WIDTH}s│${NC}\n" "   Pironman 5 Terminal Stats   "
    echo -e "${CYAN}╰${LINE}╯${NC}\n"

    # --- Infos système ---
    echo -e "IP: ${CYAN}${IP}${NC} | Ventilo: ${FAN_STATUS}"
    echo -e "Temp CPU: ${TEMP_COLOR}${TEMP_C}°C${NC}\n"

    # --- CPU cores ---
    get_cpu_usage
    CORE_COUNT=$(nproc)
    for ((i=0; i<CORE_COUNT; i++)); do
        LOAD=${CPU_USAGES[$i]}
        BAR=$(make_bar "$LOAD" "$BAR_LEN")
        printf "CPU%-2s: %3s%% |" "$i" "$LOAD"
        echo -ne "$BAR"
        echo "|"
    done
    
    echo ""
    # --- RAM ---
    RAM_BAR=$(make_bar "$RAM_USED" "$BAR_LEN")
    printf "RAM  : %3s%% |" "$RAM_USED"
    echo -ne "$RAM_BAR"
    echo "|"

    sleep "$SLEEP_INTERVAL"
done
