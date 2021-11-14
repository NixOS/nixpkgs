#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
# shellcheck shell=bash

set -eu -o pipefail

readonly plugin_name="$1"
readonly latest_version="$(curl "https://grafana.com/api/plugins/${plugin_name}" | jq -r .version)"
update-source-version "grafanaPlugins.${plugin_name}" "$latest_version"
