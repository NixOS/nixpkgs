#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -eu -o pipefail

curl "https://grafana.com/api/plugins" | jq .items > plugins.json
