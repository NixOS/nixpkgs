#! /bin/sh -e
if test -z "$NIXOS_CONFIG"; then
    NIXOS_CONFIG=/etc/nixos/configuration.nix
fi
nix-build configuration/system.nix \
    --arg configuration "import $NIXOS_CONFIG" \
    -A system -K -k
./result/bin/switch-to-configuration test
