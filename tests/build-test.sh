#!/bin/sh

cd $(dirname $0)

for profile in $(find .. -name \*.nix); do
    echo $profile >&2
    nixos-rebuild -I nixos-config=build-test.nix -I nixos-hardware-profile=$profile dry-build
done
