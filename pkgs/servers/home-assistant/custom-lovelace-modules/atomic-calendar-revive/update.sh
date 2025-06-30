#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update git
# shellcheck shell=bash

ROOT=$(git rev-parse --show-toplevel)
ATTR=home-assistant-custom-lovelace-modules.atomic-calendar-revive

cd "$ROOT" || exit 1

# get current version in nixpkgs
CURRENT_VERSION=$(nix eval -f ./default.nix --raw "$ATTR")

# get latest release tag
LATEST_RELEASE=$(curl https://api.github.com/repos/totaldebug/atomic-calendar-revive/releases | jq "[.[] | select(.prerelease == false)][0].tag_name")

# strip version prefix
LATEST_VERSION=${LATEST_RELEASE//"v"}

# strip quotes
LATEST_VERSION=${LATEST_VERSION%\"}
LATEST_VERSION=${LATEST_VERSION#\"}

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ];
then
  echo Already on latest version
  exit 0
fi

echo "Updating to ${LATEST_VERSION}"

PKGDIR=$(dirname "$0")

# change to package directory
cd "$PKGDIR" || exit 1

# update package.json
echo "https://raw.githubusercontent.com/totaldebug/atomic-calendar-revive/v${LATEST_VERSION}/package.json"
curl -o ./package.json "https://raw.githubusercontent.com/totaldebug/atomic-calendar-revive/v${LATEST_VERSION}/package.json"

# update package
cd "$ROOT" || exit 1
nix-update --version "$LATEST_VERSION" "$ATTR"
