#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../.. -i bash -p nix curl jq nix-update

# check if composer2nix is installed
if ! command -v composer2nix &> /dev/null; then
  echo "Please install composer2nix (https://github.com/svanderburg/composer2nix) to run this script."
  exit 1
fi

CURRENT_VERSION=$(nix eval -f ../../../.. --raw pixelfed.version)
TARGET_VERSION_REMOTE=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} https://api.github.com/repos/pixelfed/pixelfed/releases/latest | jq -r ".tag_name")
TARGET_VERSION=${TARGET_VERSION_REMOTE:1}
PIXELFED=https://github.com/pixelfed/pixelfed/raw/$TARGET_VERSION_REMOTE
SHA256=$(nix-prefetch-url --unpack "https://github.com/pixelfed/pixelfed/archive/v$TARGET_VERSION/pixelfed.tar.gz")
SRI_HASH=$(nix hash to-sri --type sha256 "$SHA256")

if [[ "$CURRENT_VERSION" == "$TARGET_VERSION" ]]; then
  echo "pixelfed is up-to-date: ${CURRENT_VERSION}"
  exit 0
fi

curl -LO "$PIXELFED/composer.json"
curl -LO "$PIXELFED/composer.lock"

composer2nix --name "pixelfed" \
  --composition=composition.nix \
  --no-dev
rm composer.json composer.lock

# change version number
sed -e "s/version =.*;/version = \"$TARGET_VERSION\";/g" \
    -e "s/hash =.*;/hash = \"$SRI_HASH\";/g" \
    -i ./default.nix

cd ../../../..
nix-build -A pixelfed
