#!/usr/bin/env sh

set -e

declare -r dir=$(dirname $(readlink -f $0))
declare -r derivation="${dir}/default.nix"
declare -r version=$(grep 'version =' "${derivation}" | sed 's|version = "\([0-9\.]*\)";|\1|' | tr -d '[:space:]')
declare -r scalaVersion=$(grep 'scalaVersion =' "${derivation}" | sed 's|scalaVersion = "\([0-9\.]*\)";|\1|' | tr -d '[:space:]')
declare -r sha256=$(grep 'sha256 =' "${derivation}" | sed 's|sha256 = "\([0-9a-z]*\)";|\1|' | tr -d '[:space:]')
declare -r url=$(grep 'url =' "${derivation}" | sed 's|url = "\(.*\)";|\1|' | tr -d '[:space:]')

source "${dir%%*pkgs/*}nixos/lib/increase-semver.sh"

declare -r oldUrl=$(eval echo ${url})

declare -r nextPatch=$(increaseSemver ${version} p)
declare -r nextMinor=$(increaseSemver ${version} m)
declare -r nextMajor=$(increaseSemver ${version} M)

function checkForVersion() {
  local nextVersion=$1
  local nextUrl=$(echo ${oldUrl} | sed "s|${version}|${nextVersion}|g")

  curl --output /dev/null --silent --head --fail "${nextUrl}" || return 1

  declare -r sha=$(nix-prefetch-url "${nextUrl}")

  sed -i "s|version = .*|version = \"${nextVersion}\";|g" ${derivation}
  sed -i "s|sha256 = .*|sha256 = \"${sha}\";|g" ${derivation}
}

checkForVersion ${nextPatch} || checkForVersion ${nextMinor} || checkForVersion ${nextMajor} || echo "No update"
