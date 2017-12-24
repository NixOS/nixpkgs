#!/bin/sh

cd $(dirname $0)/..

skip_paths=(
    ./inversepath/usbarmory/*
    ./tests/*
)

find=(find . -name *.nix)

for path in ${skip_paths[@]}; do
    find+=(-not -path $path)
done

for profile in `${find[@]}`; do
    echo evaluating $profile >&2

    nixos-rebuild \
	-I nixos-config=tests/eval-test.nix \
	-I nixos-hardware-profile=$profile \
	dry-build

    if [ $? -ne 0 ]; then
	exit 1
    fi
done
