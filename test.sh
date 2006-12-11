#! /bin/sh
set -e
nix-build configuration/system.nix \
    --arg configuration 'import ./instances/example.nix' \
    -A system -K -k
./result/bin/switch-to-configuration test
