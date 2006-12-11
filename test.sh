#! /bin/sh
set -e
nix-build configuration/system-configuration.nix -A system -K -k
./result/bin/switch-to-configuration test
