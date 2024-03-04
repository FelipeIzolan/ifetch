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

ID=$(($RANDOM % 808 + 1))
SPRITE=$(cat "$(dirname $0)/colorscripts/${ID}" | sed -e 's/$/[0m/g')

HOST_NAME=$(cat /sys/devices/virtual/dmi/id/product_name) 
HOST_VERSION=$(cat /sys/devices/virtual/dmi/id/product_version)
TOTAL_MEMORY=$(free -m | awk 'NR==2 {print $2}')
USAGE_MEMORY=$(free -m | awk 'NR==2 {print $3}')
COLOR="$BLACK $RED $GREEN $YELLOW $BLUE $PURPLE $CYAN $WHITE $RESET"

out=$(
cat << EOF
# ${PURPLE}$USER@$HOSTNAME${RESET}
├─ ${BLUE}os${RESET}: $ID
├─ ${BLUE}host${RESET}: $HOST_NAME $HOST_VERSION
├─ ${BLUE}kernel${RESET}: $(uname -r)
├─ ${BLUE}memory${RESET}: ${USAGE_MEMORY}/${TOTAL_MEMORY} Mib
└─ $COLOR
EOF
)

out=$(gum style --margin "0 2" "${out}")
out=$(gum join --align center --horizontal "${SPRITE}" "${out}")
out=$(gum style --margin "0 2" "${out}")

echo "${out}"
