#!/bin/bash

. /etc/os-release

BLACK='\E[0;30m'
RED='\E[0;31m'
GREEN='\E[0;32m'
YELLOW='\E[0;33m'
BLUE='\E[0;34m'
PURPLE='\E[0;35m'
CYAN='\E[0;36m'
WHITE='\E[0;37m'
RESET='\E[0m'

line() {
  echo "├─ ${BLUE}$1${RESET}: $2\n"
}

FETCH=""

add() {
  if [[ "$1" == "user" ]]; then
    FETCH="# ${PURPLE}$USER@$HOSTNAME${RESET}\n"
    return
  fi

  if [[ "$1" == "color" ]]; then
    FETCH="${FETCH}└─ $BLACK $RED $GREEN $YELLOW $BLUE $PURPLE $CYAN $WHITE $RESET\n"
    return
  fi
  
  if [[ "$1" == "os" ]]; then
    FETCH="${FETCH}$(line "OS" "$ID")"
    return
  fi

  if [[ "$1" == "host" ]]; then
    HOST_NAME=$(cat /sys/devices/virtual/dmi/id/product_name) 
    HOST_VERSION=$(cat /sys/devices/virtual/dmi/id/product_version)
    FETCH="${FETCH}$(line "Host" "$HOST_NAME ($HOST_VERSION)")"
    return
  fi

  if [[ "$1" == "kernel" ]]; then
    FETCH="${FETCH}$(line "Kernel" "$(uname -r)")"
    return
  fi

  if [[ "$1" == "uptime" ]]; then
    FETCH="${FETCH}$(line "Uptime" "$(uptime -p)")"
    return
  fi

  if [[ "$1" == "shell" ]]; then
    FETCH="${FETCH}$(line "Shell" "$(basename $SHELL)")"
    return
  fi

  if [[ "$1" == "memory" ]]; then
    TOTAL_MEMORY=$(free -m | awk 'NR==2 {print $2}')
    USAGE_MEMORY=$(free -m | awk 'NR==2 {print $3}')
    FETCH="${FETCH}$(line "Memory" "${USAGE_MEMORY} / ${TOTAL_MEMORY} Mib")"
    return
  fi

  if [[ "$1" == "swap" ]]; then
    TOTAL_MEMORY=$(free -m | awk 'NR==3 {print $2}')
    USAGE_MEMORY=$(free -m | awk 'NR==3 {print $3}')
    FETCH="${FETCH}$(line "Swap" "${USAGE_MEMORY} / ${TOTAL_MEMORY} Mib")"
    return
  fi

  if [[ "$1" == "cpu" ]]; then
    FETCH="${FETCH}$(line "CPU" "$(lscpu | grep 'Model name' | cut -f 2 -d ":" | awk '{$1=$1}1')")"
    return
  fi

  if [[ "$1" == "local ip" ]]; then
    FETCH="${FETCH}$(line "Local IP" "$(ip route get 1.2.3.4 | awk '{print $7}')")"
    return
  fi

  if [[ "$1" == "locale" ]]; then
    FETCH="${FETCH}$(line "Locale" "$LANG")"
    return
  fi
}

###############################################################

add "user" # start
add "os"
add "host"
add "kernel"
add "uptime"
add "shell"
add "memory"
add "swap"
# add "cpu"
# add "local ip"
# add "locale"
add "color" # end

###############################################################

PID=$(shuf -i 1-809 -n 1)

readarray -t sprite <<< $(cat "$(dirname $0)/colorscripts/${PID}" | sed -e 's/$/\\E[0m/g' | sed '$d')
readarray -t info <<< $(printf "$FETCH")

width="${sprite[0]}"
width="${width//[^▀▄ ]}"
width="${#width}"

slen=${#sprite[@]}
ilen=${#info[@]}

printf '\n'
if [ $slen -ge $ilen ]; then
  center=$((($slen - $ilen) / 2))
  for ((i=0; i <= $slen; i++)); do
    printf "   ${sprite[i]}"
    if [ $i -ge $center ]; then
      echo "   ${info[$(($i-$center))]}"
    else
      echo ""
    fi
  done
else
  center=$((($ilen - $slen) / 2))
  for ((i=0; i <= $ilen; i++)); do
    if [ $i -ge $center -a $i -lt $(($center + $slen)) ]; then
      printf "   ${sprite[$(($i-$center))]}"
    else
      printf "   "
      printf ' %.0s' $(seq $width)
    fi
    echo "   ${info[i]}"
  done
fi
