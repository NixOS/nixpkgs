#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused

set -euo pipefail

# e.g. linux-gecko-20220331-59d0a686993f-ffd8d6280276
BUILD_ID=$(curl https://static.replay.io/downloads/linux-replay.json | jq .buildId -r)
REVISION=$(echo $BUILD_ID | sed 's/^.*-//')
NODE_BUILD_ID=$(curl https://static.replay.io/downloads/linux-replay-node.json | jq .buildId -r)

REPLAY_DL=https://static.replay.io/downloads/${BUILD_ID}.tar.bz2
LIB_DL=https://static.replay.io/downloads/linux-recordreplay-${REVISION}.tgz
NODE_DL=https://static.replay.io/downloads/${NODE_BUILD_ID}


cat >"${BASH_SOURCE%/*}/meta.json" <<EOF
{
  "replay": {
     "url": "${REPLAY_DL}",
     "sha256": "$(nix-prefetch-url --type sha256 "${REPLAY_DL}")"
  },
  "recordreplay": {
     "url": "${LIB_DL}",
     "sha256": "$(nix-prefetch-url --type sha256 --unpack "${LIB_DL}")",
     "stripRoot": false
  },
  "replay-node": {
      "url": "${NODE_DL}",
      "sha256": "$(nix-prefetch-url --type sha256 "${NODE_DL}")"
  }
}
EOF
