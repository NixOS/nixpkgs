#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix-prefetch-svn git curl
set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
path="$nixpkgs/pkgs/os-specific/linux/kernel/linux-libre.nix"

old_rev="$(grep -o 'rev = ".*"' "$path" | awk -F'"' '{print $2}')"

svn_url=https://www.fsfla.org/svn/fsfla/software/linux-libre/releases/branches/
rev="$(curl -s "$svn_url" | grep -Em 1 -o 'Revision [0-9]+' | awk '{print $2}')"

if [ "$old_rev" = "$rev" ]; then
    echo "No updates for linux-libre"
    exit 0
fi

sha256="$(QUIET=1 nix-prefetch-svn "$svn_url" "$rev" | tail -1)"

sed -i -e "s/rev = \".*\"/rev = \"$rev\"/" \
    -e "s/sha256 = \".*\"/sha256 = \"$sha256\"/" "$path"

if [ -n "$COMMIT" ]; then
    git commit -qm "linux_latest-libre: $old_rev -> $rev" "$path"
    echo "Updated linux_latest-libre $old_rev -> $rev"
fi
