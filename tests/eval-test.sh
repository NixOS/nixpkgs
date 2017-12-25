#!/bin/sh

cd $(dirname $0)/..

find=(find . -name default.nix)

for profile in `${find[@]}`; do
    echo evaluating $profile >&2

    nix-build '<nixpkgs/nixos>' \
        -I nixos-config=tests/eval-test.nix \
        -I nixos-hardware-profile=$profile \
        -A system \
        --dry-run

    if [ $? -ne 0 ]; then
	exit 1
    fi
done
