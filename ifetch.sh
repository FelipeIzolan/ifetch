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

PID=$(shuf -i 1-809 -n 1)

HOST_NAME=$(cat /sys/devices/virtual/dmi/id/product_name) 
HOST_VERSION=$(cat /sys/devices/virtual/dmi/id/product_version)
TOTAL_MEMORY=$(free -m | awk 'NR==2 {print $2}')
USAGE_MEMORY=$(free -m | awk 'NR==2 {print $3}')
COLOR="$BLACK $RED $GREEN $YELLOW $BLUE $PURPLE $CYAN $WHITE $RESET"

readarray -t sprite <<< $(cat "$(dirname $0)/colorscripts/${PID}" | sed -e 's/$/\\E[0m/g')
readarray -t info <<< $(
cat << EOF
# ${PURPLE}$USER@$HOSTNAME${RESET}
├─ ${BLUE}os${RESET}: $ID
├─ ${BLUE}host${RESET}: $HOST_NAME $HOST_VERSION
├─ ${BLUE}kernel${RESET}: $(uname -r)
├─ ${BLUE}memory${RESET}: ${USAGE_MEMORY}/${TOTAL_MEMORY} Mib
└─ $COLOR
EOF
)

cs=$(((${#sprite[@]} - 7) / 2))

printf "\n\n"
for ((i=0; i <= ${#sprite[@]}; i++))
do
  line="  ${sprite[i]}"
  if [ $i -ge $cs ]
  then
    line+="  ${info[$(($i-$cs))]}"
  fi
  printf "$line\n"
done
