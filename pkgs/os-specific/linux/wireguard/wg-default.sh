#! /usr/bin/env bash
set -x
WG="@out@/bin/wg"
IP="@iproute@/bin/ip"

if [[ $# -lt 2 ]] || [[ "$1" != "add" && "$1" != "rm" ]] || [[ "$1" == "add" && $# -ne 3 ]] || [[ "$1" == "rm" && $# -ne 2 ]]; then
  echo "Usage: $0 [add|rm] interface [ipaddrToAdd]"
  exit 1
fi

INTERFACE="$2"

fwmark="$($WG show $INTERFACE fwmark)"
DEFAULT_TABLE=0
[[ $fwmark != off ]] && DEFAULT_TABLE=$(( fwmark ))

if [[ "$1" == add ]]; then
  # Add default route
  if [[ $DEFAULT_TABLE -eq 0 ]]; then
    DEFAULT_TABLE=51820
    while [[ -n $($IP -4 route show table $DEFAULT_TABLE) || -n $($IP -6 route show table $DEFAULT_TABLE) ]]; do
      ((DEFAULT_TABLE++))
    done
  fi
  ipaddr="$3"
  proto=-4
  [[ "$ipaddr" == *:* ]] && proto=-6
  $WG set "$INTERFACE" fwmark $DEFAULT_TABLE
  $IP $proto route add "$ipaddr" dev "$INTERFACE" table $DEFAULT_TABLE
  $IP $proto rule add not fwmark $DEFAULT_TABLE table $DEFAULT_TABLE
  $IP $proto rule add table main suppress_prefixlength 0
else
  # Remove default routes
  if [[ $DEFAULT_TABLE -ne 0 ]]; then
    while [[ $($IP -4 rule show) == *"lookup $DEFAULT_TABLE"* ]]; do
      $IP -4 rule delete table $DEFAULT_TABLE
    done
    while [[ $($IP -4 rule show) == *"from all lookup main suppress_prefixlength 0"* ]]; do
      $IP -4 rule delete table main suppress_prefixlength 0
    done
    while [[ $($IP -6 rule show) == *"lookup $DEFAULT_TABLE"* ]]; do
      $IP -6 rule delete table $DEFAULT_TABLE
    done
    while [[ $($IP -6 rule show) == *"from all lookup main suppress_prefixlength 0"* ]]; do
      $IP -6 rule delete table main suppress_prefixlength 0
    done
  fi
fi
