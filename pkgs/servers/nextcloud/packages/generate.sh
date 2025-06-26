#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../.. -i bash -p nc4nix jq

set -e
set -u
set -o pipefail
set -x

export NEXTCLOUD_VERSIONS=$(nix-instantiate --eval -E 'import ./nc-versions.nix {}' -A e)

nc4nix
rm *.log
