#! /bin/sh -e
if test -z "$NIXOS_CONFIG"; then
    NIXOS_CONFIG=/etc/nixos/configuration.nix
fi
nix-env -p /nix/var/nix/profiles/system -f system/system.nix \
    --arg configuration "import $NIXOS_CONFIG" \
    --set -A system
/nix/var/nix/profiles/system/bin/switch-to-configuration switch
