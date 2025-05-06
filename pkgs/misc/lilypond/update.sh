#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl gnused nix

set -euo pipefail

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

if [ $# -gt 0 ] && [ "$1" = "unstable" ]; then
    ATTR="lilypond-unstable"
    FILE="${SCRIPT_DIRECTORY})/unstable.nix"
    QUERY="VERSION_DEVEL="
else
    ATTR="lilypond"
    FILE="${SCRIPT_DIRECTORY}/default.nix"
    QUERY="VERSION_STABLE="
fi

# update version
PREV=$(nix eval --raw -f default.nix $ATTR.version)
NEXT=$(curl -s 'https://gitlab.com/lilypond/lilypond/-/raw/master/VERSION' | grep "$QUERY" | cut -d= -f2)
sed -i "s|$PREV|$NEXT|" "$FILE"
echo "[{\"commitMessage\":\"$ATTR: $PREV -> $NEXT\"}]"

# update hash
PREV=$(nix eval --raw -f default.nix $ATTR.src.outputHash)
NEXT=$(nix hash to-sri --type sha256 $(nix-prefetch-url --type sha256 --unpack $(nix eval --raw -f default.nix $ATTR.src.url)))
sed -i "s|$PREV|$NEXT|" "$FILE"
