#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl gnused nix

set -euo pipefail

if [ $# -gt 0 ] && [ "$1" = "unstable" ]; then
    ATTR="lilypond-unstable"
    FILE="$(dirname "${BASH_SOURCE[@]}")/unstable.nix"
    QUERY="VERSION_DEVEL="
else
    ATTR="lilypond"
    FILE="$(dirname "${BASH_SOURCE[@]}")/default.nix"
    QUERY="VERSION_STABLE="
fi

# update version
PREV=$(nix eval --raw -f default.nix $ATTR.version)
NEXT=$(curl -s 'https://gitlab.com/lilypond/lilypond/-/raw/master/VERSION' | grep "$QUERY" | cut -d= -f2)
sed -i "s|$PREV|$NEXT|" "$FILE"
echo "[{\"commitMessage\":\"$ATTR: $PREV -> $NEXT\"}]"

# update hash
PREV=$(nix eval --raw -f default.nix $ATTR.src.outputHash)
NEXT=$(nix hash to-sri --type sha256 $(nix-prefetch-url --type sha256 $(nix eval --raw -f default.nix $ATTR.src.url)))
sed -i "s|$PREV|$NEXT|" "$FILE"
