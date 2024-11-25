#!/usr/bin/env nix
#!nix shell
#!nix ``nixpkgs/nixos-24.05#nix-prefetch-git``
#!nix ``nixpkgs/nixos-24.05#bash``
#!nix --command bash

# This copies the required packaging files from a nix clone, as Nixpkgs can't
# import from remote sources for valid performance reasons.

set -euo pipefail

set -x

usage() {
  cat <<EOF
Usage: $0 subdir [OPTIONS]

Example:
  $0 2_25

EOF
}

if [[ $# == 0 ]]; then
  usage
  exit 1
fi

get_tag_refs() {
  git ls-remote --tags https://github.com/NixOS/nix.git
}
get_tags() {
  get_tag_refs \
    | sed -n 's^.*refs/tags/\([0-9][0-9.]*\)$^\1^p' \
    | sort --version-sort \
    ;
}
get_minor_tag() {
  local version="$(<<<"$1" sed 's/\./\\./g')"
  get_tags \
    | grep "^$version." \
    | tail -n 1 \
    ;
}
dir_to_version() {
  local dir="$1"
  echo "${dir//_/.}"
}

subdir="$1"

cd "$(dirname "${BASH_SOURCE[0]}")"

nixpkgs="$(realpath ../../../../..)"

tag=$(get_minor_tag "$(dir_to_version "$subdir")")
ref=refs/tags/$tag

mkdir -p "$subdir"
cd "$subdir"

nix-prefetch-github \
  --rev $ref \
  --json \
  > source.json \
  NixOS nix

nix="$(
  nix build \
    --impure --no-link --print-out-paths \
    --expr \
    '{ json }: with import ../../../../.. {}; fetchFromGitHub (builtins.fromJSON json)' \
    --arg-from-file json source.json \
    ;
)";

# check that $nix looks like a Nix checkout
(
  set -x
  [[ -f "$nix/.version" ]]
  [[ -f "$nix/flake.nix" ]]
  [[ -d "$nix/src" ]]
) || {
  echo "error: The path $nix does not look like it contains the Nix sources."
  echo "       This script assumes nix and nixpkgs are siblings on your file system."
  exit 1
}

mkdir -p packaging
cp $nix/packaging/components.nix ./packaging/
(
  find $nix -name package.nix -mindepth 2
  echo $nix/packaging/everything.nix
  echo $nix/.version
) | while read f; do
  rel=$(realpath --relative-to $nix $f)
  reldir=$(dirname $rel)
  (
    set -x
    mkdir -p $reldir
    cp --no-preserve=mode $nix/$rel $rel
  )
done
