#!/bin/sh

. /etc/os-release

BLACK='[0;30m'
RED='[0;31m'
GREEN='[0;32m'
YELLOW='[0;33m'
BLUE='[0;34m'
PURPLE='[0;35m'
CYAN='[0;36m'
WHITE='[0;37m'
RESET='[0m'

PID=$(($RANDOM % 808 + 1))

HOST_NAME=$(cat /sys/devices/virtual/dmi/id/product_name) 
HOST_VERSION=$(cat /sys/devices/virtual/dmi/id/product_version)
TOTAL_MEMORY=$(free -m | awk 'NR==2 {print $2}')
USAGE_MEMORY=$(free -m | awk 'NR==2 {print $3}')
COLOR="$BLACK $RED $GREEN $YELLOW $BLUE $PURPLE $CYAN $WHITE $RESET"

sprite=(); readarray -t sprite <<< $(cat "$(dirname $0)/colorscripts/${PID}" | sed -e 's/$/[0m/g')
info=(); readarray -t info <<< $(
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
