#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq nixVersions.latest
set -euo pipefail

# Generate a list of attr paths that are different when enableRocm = true
# Special case python3*Packages to only build the default python3Packages
rocmDir=$(dirname "$(realpath "$0")")

pkgsTmp=$(mktemp)
pkgsRocmTmp=$(mktemp)
trap "rm -f $pkgsTmp $pkgsRocmTmp" EXIT

echo "Generating attrPaths to compare for pkgs and pkgsRocm" >&2

{
  nix-instantiate --eval --strict --json "$rocmDir/release-attrPaths-gen.nix" \
    --argstr variant pkgs > "$pkgsTmp" &
  nix-instantiate --eval --strict --json "$rocmDir/release-attrPaths-gen.nix" \
    --argstr variant pkgsRocm > "$pkgsRocmTmp" &
  wait
}

<"$pkgsRocmTmp" >"$rocmDir/release-attrPaths.json" jq --slurpfile def "$pkgsTmp" '
{
  "__generatedBy": "'"$0"'",
  "attrPaths": [
    ($def[0] | map({(.p): .o}) | add) as $def_map |
    .[] |
    select(
      ($def_map[.p] == null) or
      ($def_map[.p] != .o)
    ) |
    .p |
    gsub("python3\\d+Packages"; "python3Packages")
  ] | unique
}
'

echo "Generated $rocmDir/release-attrPaths.json" >&2
