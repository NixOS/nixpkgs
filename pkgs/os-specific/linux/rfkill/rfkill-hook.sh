#!/bin/sh

# Executes a hook in case of a change to the
# rfkill state. The hook can be passed as
# environment variable, or present as executable
# file.

if [ -z "$RFKILL_STATE" ]; then
  echo "rfkill-hook: error: RFKILL_STATE variable not set"
  exit 1
fi

if [ -x /var/run/current-system/etc/rfkill.hook ]; then
  exec /var/run/current-system/etc/rfkill.hook
elif [ ! -z "$RFKILL_HOOK" ]; then
  exec $RFKILL_HOOK
else
  echo "rfkill-hook: $RFKILL_STATE"
fi