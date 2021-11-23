#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq
# shellcheck shell=bash

set -euo pipefail

basedir="$(git rev-parse --show-toplevel)"
version="$(curl -sL https://cdn.cypress.io/desktop/ | jq '.version' --raw-output)"

cd "$basedir"
update-source-version cypress "$version"
