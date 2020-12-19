#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cabal2nix jq curl
#
# This script will update the haskell-language-server derivation to the latest version using
# cabal2nix.
#
# Note that you should always try building haskell-language-server after updating it here, since
# some of the overrides in pkgs/development/haskell/configuration-nix.nix may
# need to be updated/changed.
#
# Remember to split out different updates into multiple commits

set -eo pipefail

# This is the directory of this update.sh script.
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# ===========================
# HLS
# ===========================

# hls derivation created with cabal2nix.
hls_derivation_file="${script_dir}/default.nix"

# This is the current revision of hls in Nixpkgs.
hls_old_version="$(sed -En 's/.*\bversion = "(.*?)".*/\1/p' "$hls_derivation_file")"

# This is the latest release version of hls on GitHub.
# Get all tag names, filter to the hls ones (no prefix like 'hls-plugin-api-'),
# sort for the latest one and select just that
hls_latest_release=$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/haskell/haskell-language-server/tags |
  jq --raw-output 'map(.name) | .[]' |
  grep '^[0-9]' |
  sort --version-sort |
  tail -n1)

# Use this value instead for the very latest revision
# hls_head=(curl --silent "https://api.github.com/repos/haskell/haskell-language-server/commits/master" | jq '.sha' --raw-output)

hls_new_version=$hls_latest_release

echo "Updating haskell-language-server from old version $hls_old_version to new version $hls_new_version."
echo "Running cabal2nix and outputting to ${hls_derivation_file}..."

cabal2nix --revision "$hls_new_version" "https://github.com/haskell/haskell-language-server.git" > "$hls_derivation_file"
cabal2nix --revision "$hls_new_version" --subpath plugins/tactics "https://github.com/haskell/haskell-language-server.git" > "${script_dir}/hls-tactics-plugin.nix"
cabal2nix --revision "$hls_new_version" --subpath plugins/hls-hlint-plugin "https://github.com/haskell/haskell-language-server.git" > "${script_dir}/hls-hlint-plugin.nix"
cabal2nix --revision "$hls_new_version" --subpath plugins/hls-explicit-imports-plugin "https://github.com/haskell/haskell-language-server.git" > "${script_dir}/hls-explicit-imports-plugin.nix"
cabal2nix --revision "$hls_new_version" --subpath plugins/hls-retrie-plugin "https://github.com/haskell/haskell-language-server.git" > "${script_dir}/hls-retrie-plugin.nix"

echo "Finished."
