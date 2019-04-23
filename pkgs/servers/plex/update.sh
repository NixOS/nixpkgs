#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils curl findutils jq

set -eu -o pipefail

manifest=$(curl -s https://plex.tv/api/downloads/5.json)
version=$(echo "$manifest" | jq -r '.computer.Linux.version | split("-") | .[0]')

# Mapping of nixpkgs platform to plex platform.
systems='{"i686-linux": "linux-x86", "x86_64-linux": "linux-x86_64"}'

for system in "i686-linux" "x86_64-linux"; do
  # The script will not perform an update when the version attribute is updated for the previous
  # system, so we need to clear it before each run.
  update-source-version plex 0 0000000000000000000000000000000000000000000000000000000000000000 \
   --system=$system

  echo "$manifest" \
      | jq -r --arg system "$system" --argjson systems "$systems" '
        ($systems | .[$system]) as $build
        | .computer.Linux.releases
        | map(select(.distro == "redhat" and .build == $build))
        | .[]
        | .url' \
      | xargs -i update-source-version plex "$version" '' {} --system=$system
done
