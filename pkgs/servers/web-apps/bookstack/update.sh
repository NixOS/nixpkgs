#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix curl jq nix-update
# shellcheck shell=bash

# check if composer2nix is installed
if ! command -v composer2nix &> /dev/null; then
  echo "Please install composer2nix (https://github.com/svanderburg/composer2nix) to run this script."
  exit 1
fi

CURRENT_VERSION=$(nix eval --raw '(with import ../../../.. {}; bookstack.version)')
TARGET_VERSION_REMOTE=$(curl https://api.github.com/repos/bookstackapp/bookstack/releases/latest | jq -r ".tag_name")
TARGET_VERSION=${TARGET_VERSION_REMOTE:1}
BOOKSTACK=https://github.com/bookstackapp/bookstack/raw/$TARGET_VERSION_REMOTE
SHA256=$(nix-prefetch-url --unpack "https://github.com/bookstackapp/bookstack/archive/v$TARGET_VERSION/bookstack.tar.gz")

if [[ "$CURRENT_VERSION" == "$TARGET_VERSION" ]]; then
  echo "bookstack is up-to-date: ${CURRENT_VERSION}"
  exit 0
fi

curl -LO "$BOOKSTACK/composer.json"
curl -LO "$BOOKSTACK/composer.lock"

composer2nix --name "bookstack" \
  --composition=composition.nix \
  --no-dev
rm composer.json composer.lock

# change version number
sed -e "s/version =.*;/version = \"$TARGET_VERSION\";/g" \
    -e "s/sha256 =.*;/sha256 = \"$SHA256\";/g" \
    -i ./default.nix

# fix composer-env.nix
sed -e "s/stdenv\.lib/lib/g" \
    -e '3s/stdenv, writeTextFile/stdenv, lib, writeTextFile/' \
    -i ./composer-env.nix

# fix composition.nix
sed -e '7s/stdenv writeTextFile/stdenv lib writeTextFile/' \
    -i composition.nix

# fix missing newline
echo "" >> composition.nix
echo "" >> php-packages.nix

cd ../../../..
nix-build -A bookstack

exit $?
