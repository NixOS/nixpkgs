#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl -p jq

set -eu -o pipefail

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

curl https://translatelocally.com/models.json \
  | jq '.models | map(with_entries(select([.key] | inside([
      "name",
      "code",
      "version",
      "url",
      "checksum"
    ]))))' \
  > "${SCRIPT_DIRECTORY}/models.json"
