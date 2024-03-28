#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash curl jq

set -e

urls=(
  https://out7.hex-rays.com/files/idafree82_linux.run
  https://out7.hex-rays.com/files/idafree82_mac.app.zip
  https://out7.hex-rays.com/files/arm_idafree82_mac.app.zip
)

archs=(
  x86_64-linux
  x86_64-darwin
  aarch64-darwin
)

hashes=()
for u in "${urls[@]}"; do
  hash=$(nix-prefetch-url $u)
  hashes=("${hashes[@]}" "$hash")
done

for ((i = 0; i < ${#urls[@]}; i++)); do
  echo '{"key":"'${archs[i]}'", "value":{"url":"'${urls[i]}'", "sha256":"'${hashes[i]}'"}}'
done | jq -s from_entries >pkgs/development/tools/analysis/ida-free/srcs.json
