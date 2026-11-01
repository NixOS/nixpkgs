#! /usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts python3
# shellcheck shell=bash

set -ueo pipefail

version="$(python "$(dirname "${BASH_SOURCE[0]}")"/latest_version.py)"
update-source-version dictdDBs.wiktionary "$version"
