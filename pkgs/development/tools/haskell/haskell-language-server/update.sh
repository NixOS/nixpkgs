#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cabal2nix jq curl
#
# This script will update the haskell-language-server derivation to the latest version using
# cabal2nix.
#
# Note that you should always try building haskell-language-server after updating it here, since
# some of the overrides in pkgs/development/haskell/configuration-nix.nix may
# need to be updated/changed.

set -eo pipefail

# This is the directory of this update.sh script.
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# ===========================
# ghcide fork on https://github.com/wz1000/ghcide
# ===========================

# ghcide derivation created with cabal2nix.
ghcide_derivation_file="${script_dir}/hls-ghcide.nix"

# This is the current revision of hls in Nixpkgs.
ghcide_old_version="$(sed -En 's/.*\bversion = "(.*?)".*/\1/p' "$ghcide_derivation_file")"

# This is the revision of ghcide used by hls on GitHub.
ghcide_new_version=$(curl --silent "https://api.github.com/repos/haskell/haskell-language-server/contents/ghcide" | jq '.sha' --raw-output)

echo "Updating haskell-language-server from old version $ghcide_old_version to new version $ghcide_new_version."
echo "Running cabal2nix and outputting to ${ghcide_derivation_file}..."

cabal2nix --revision "$ghcide_new_version" "https://github.com/bubba/ghcide" > "$ghcide_derivation_file"


# ===========================
# HLS
# ===========================

# hls derivation created with cabal2nix.
hls_derivation_file="${script_dir}/default.nix"

# This is the current revision of hls in Nixpkgs.
hls_old_version="$(sed -En 's/.*\bversion = "(.*?)".*/\1/p' "$hls_derivation_file")"

# This is the latest release version of hls on GitHub.
hls_new_version=$(curl --silent "https://api.github.com/repos/haskell/haskell-language-server/commits/master" | jq '.sha' --raw-output)

echo "Updating haskell-language-server from old version $hls_old_version to new version $hls_new_version."
echo "Running cabal2nix and outputting to ${hls_derivation_file}..."

cabal2nix --revision "$hls_new_version" "https://github.com/haskell/haskell-language-server.git" > "$hls_derivation_file"

echo "Finished."
