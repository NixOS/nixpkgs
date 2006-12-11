#! /bin/sh
set -e
nix-build configuration/system-configuration.nix -A systemConfiguration -K -k
./result/bin/switch-to-configuration test
