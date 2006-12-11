#! /bin/sh
set -e
nix-env -p /nix/var/nix/profiles/system -f configuration/system.nix \
    --arg configuration 'import ./instances/example.nix' \
    -i -A system
/nix/var/nix/profiles/system/bin/switch-to-configuration switch
