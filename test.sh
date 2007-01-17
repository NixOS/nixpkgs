#! /bin/sh -e

if test -z "$NIXOS"; then NIXOS=/etc/nixos/nixos; fi
if test -z "$NIXOS_CONFIG"; then NIXOS_CONFIG=/etc/nixos/configuration.nix; fi

nix-build $NIXOS/system/system.nix \
    --arg configuration "import $NIXOS_CONFIG" \
    -A system -K -k
./result/bin/switch-to-configuration test
