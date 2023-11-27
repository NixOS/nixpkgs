#!/usr/bin/env bash

#
# Run this from the top-level nixpkgs directory.
#

TMPFILE=$(mktemp)
nix-instantiate --impure --json --strict --eval pkgs/top-level/nohydra -A uninstantiated-attrpaths | jq -r '.[]' > $TMPFILE

export NIXPKGS_ALLOW_UNFREE=1
export NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1
export NIXPKGS_ALLOW_INSECURE=1

if [[ -s $TMPFILE ]]; then
  echo you have $(wc -l < $TMPFILE) uninstantiated attrpaths, instantiating them...
  cat $TMPFILE | sed 's/^/-A\n/' | xargs -n256 -P16 nix-instantiate .
else
  echo you have no uninstantiated attrpaths!
fi

