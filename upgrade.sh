#! /bin/sh -e
if test -z "$NIXOS_CONFIG"; then
    NIXOS_CONFIG=/etc/nixos/configuration.nix
fi
nix-env -p /nix/var/nix/profiles/system -f configuration/system.nix \
    --arg configuration "import $NIXOS_CONFIG" \
    -i -A system
/nix/var/nix/profiles/system/bin/switch-to-configuration switch
