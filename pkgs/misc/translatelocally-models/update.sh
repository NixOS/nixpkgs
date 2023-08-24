#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl -p jq

set -eu -o pipefail

curl https://translatelocally.com/models.json \
  | jq \
  > "$(dirname "$0")/models.json"
