#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl perl common-updater-scripts
# shellcheck shell=bash

version=$(curl https://xpra.org/src/ | perl -ne 'print "$1\n" if /xpra-([[:digit:].]+)\./' | sort -V | tail -n1)
update-source-version xpra "$version"
