#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused

# e.g. linux-gecko-20220331-59d0a686993f-ffd8d6280276
BUILD_ID=$(curl https://static.replay.io/downloads/linux-replay.json | jq .buildId -r)
REVISION=$(echo $BUILD_ID | sed 's/^.*-//')
DATE=$(echo $BUILD_ID | sed 's/^linux-gecko-\(\w*\).*/\1/')

REPLAY_DL=https://static.replay.io/downloads/${BUILD_ID}.tar.bz2
LIB_DL=https://static.replay.io/downloads/linux-recordreplay-${REVISION}.tgz

REPLAY_HASH=$(nix-prefetch-url --type sha256 "${REPLAY_DL}")
LIB_HASH=$(nix-prefetch-url --type sha256 "${LIB_DL}")

cat >"${BASH_SOURCE%/*}/meta.json" <<EOF
{
  "date": "${DATE}",
  "build-id": "${BUILD_ID}",
  "revision": "${REVISION}",
  "replay": {
     "url": "${REPLAY_DL}",
     "sha256": "${REPLAY_HASH}"
  },
  "recordreplay-lib": {
     "url": "${LIB_DL}",
     "sha256": "${LIB_HASH}"
  }
}
EOF
