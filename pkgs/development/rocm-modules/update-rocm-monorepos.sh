#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils git gnugrep gnused
# shellcheck shell=bash

set -euo pipefail

die() {
  echo "$*" >&2
  exit 1
}

nixpkgs="$(git rev-parse --show-toplevel)" || die "Run this script from within the nixpkgs checkout."
readonly nixpkgs
readonly fake_hash="sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
readonly rocm_libraries_repo=https://github.com/ROCm/rocm-libraries.git
readonly rocm_systems_repo=https://github.com/ROCm/rocm-systems.git
readonly version_file="$nixpkgs/pkgs/development/rocm-modules/default.nix"

latest_version() {
  local repo_name=$1 repo_url=$2 version

  version="$(
    list-git-tags --url="$repo_url" \
      | sed -n -E 's/^rocm-([0-9]+\.[0-9]+(\.[0-9]+)?)$/\1/p' \
      | sort --reverse --version-sort \
      | head -n1
  )"

  if [[ -z $version ]]; then
    die "Could not determine the latest $repo_name tag."
  fi

  printf '%s\n' "$version"
}

rocm_libraries_version="$(latest_version rocm-libraries "$rocm_libraries_repo")"
rocm_systems_version="$(latest_version rocm-systems "$rocm_systems_repo")"
readonly rocm_libraries_version rocm_systems_version

if [[ $rocm_libraries_version != "$rocm_systems_version" ]]; then
  die "Latest rocm-systems ($rocm_systems_version) and rocm-libraries ($rocm_libraries_version) tags differ."
fi

readonly version="$rocm_systems_version"

# shellcheck disable=SC2016
mapfile -t package_specs < <(
  nix-instantiate --eval --strict --raw -E '
    let
      pkgs = import '"$nixpkgs"' { };
      rocmPackages = pkgs.rocmPackages;
      tryEvalOr =
        fallback: value:
        let
          result = builtins.tryEval value;
        in
        if result.success && result.value != null then result.value else fallback;
      toPackageSpec =
        name:
        let
          pkg = builtins.getAttr name rocmPackages;
          srcDrvAttrs = tryEvalOr { } (pkg.src.drvAttrs or null);
          position = tryEvalOr null (pkg.meta.position or null);
          repo = srcDrvAttrs.repo or null;
          rev = srcDrvAttrs.rev or null;
          hash = srcDrvAttrs.outputHash or null;
          file =
            if position == null then
              null
            else
              let
                match = builtins.match "^(.*):[0-9]+(:[0-9]+)?$" position;
              in
              if match == null then null else builtins.head match;
          extraUpdateScript = pkg.passthru.rocmMonorepo.extraUpdateScript or "";
        in
        if
          (repo != "rocm-libraries" && repo != "rocm-systems")
          || rev != "rocm-${rocmPackages.rocmVersion}"
          || hash == null
          || file == null
          || builtins.baseNameOf (builtins.dirOf file) != name
        then
          null
        else
          builtins.concatStringsSep "\t" [
            name
            file
            hash
            extraUpdateScript
          ];
    in builtins.concatStringsSep "\n" (builtins.filter (packageSpec: packageSpec != null) (map toPackageSpec (builtins.attrNames rocmPackages)))
  '
)

if (( ${#package_specs[@]} == 0 )); then
  die "Could not find any monorepo-backed ROCm packages to update."
fi

patch_version() {
  local file=$1 version=$2

  sed -i -E \
    "s|^([[:space:]]*rocmVersion[[:space:]]*=[[:space:]]*)\"[^\"]+\";|\1\"$version\";|" \
    "$file"

  if ! grep -Fq "\"$version\";" "$file"; then
    die "Failed to update rocmVersion in $file."
  fi
}

patch_hash() {
  local file=$1 old_hash=$2 new_hash=$3

  sed -i "s|\"$old_hash\"|\"$new_hash\"|" "$file"

  if ! grep -Fq "\"$new_hash\"" "$file"; then
    die "Failed to replace $old_hash in $file."
  fi
}

resolve_hash() {
  local package=$1 hash fetch_log

  fetch_log="$(mktemp --tmpdir "${package}.fetchlog.XXXXXX")"
  nix-build --no-out-link -A "rocmPackages.${package}.src" . > /dev/null 2> "$fetch_log" || true
  hash="$(
    sed -nE '/hash mismatch in fixed-output derivation/,$ s/.*got:[[:space:]]*(sha256-[A-Za-z0-9+/=]+).*/\1/p' "$fetch_log" \
      | tail -n1
  )"

  if [[ -z $hash ]]; then
    cat "$fetch_log" >&2
    rm -f "$fetch_log"
    die "Could not determine the new source hash for $package."
  fi

  rm -f "$fetch_log"
  printf '%s\n' "$hash"
}

patch_version "$version_file" "$version"

for package_spec in "${package_specs[@]}"; do
  IFS=$'\t' read -r package package_file old_hash extra_update_script <<< "$package_spec"

  echo "Updating $package" >&2
  patch_hash "$package_file" "$old_hash" "$fake_hash"
  new_hash="$(resolve_hash "$package")"
  patch_hash "$package_file" "$fake_hash" "$new_hash"

  if [[ -z $extra_update_script ]]; then
    continue
  fi
  [[ $extra_update_script == /* ]] || extra_update_script="${package_file%/*}/$extra_update_script"
  if [[ ! -x $extra_update_script ]]; then
    die "Expected extra updater $extra_update_script for $package to be executable."
  fi
  echo "Running extra updater for $package" >&2
  "$extra_update_script" "$version"
done
