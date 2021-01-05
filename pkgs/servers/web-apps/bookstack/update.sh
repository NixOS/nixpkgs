#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq nix-update

# you will need composer2nix to run this


CURRENT_VERSION=$(nix eval --raw '(with import ../../../.. {}; bookstack.version)')
TARGET_VERSION_REMOTE=$(curl https://api.github.com/repos/bookstackapp/bookstack/releases/latest | jq -r ".tag_name")
TARGET_VERSION=${TARGET_VERSION_REMOTE:1}
BOOKSTACK=https://github.com/bookstackapp/bookstack/raw/$TARGET_VERSION_REMOTE

echo "current=$CURRENT_VERSION"
echo "target_remote=$TARGET_VERSION_REMOTE"
echo "target=$TARGET_VERSION"

if [[ "$CURRENT_VERSION" == "$TARGET_VERSION" ]]; then
  echo "bookstack is up-to-date: ${CURRENT_VERSION}"
  exit 0
fi

curl -LO "$BOOKSTACK/composer.json"
curl -LO "$BOOKSTACK/composer.lock"

composer2nix --name "bookstack-$TARGET_VERSION" \
  --composition=composition.nix \
  --no-dev
rm composer.json composer.lock

# fix missing newline
echo "" >> composition.nix
echo "" >> php-packages.nix

{
  cd ../../../..
  nix-update --version "$TARGET_VERSION" --build bookstack
}

git add ./composer-env.nix ./composition.nix ./default.nix ./php-packages.nix
git commit -m "bookstack: ${CURRENT_VERSION} -> ${TARGET_VERSION}"
