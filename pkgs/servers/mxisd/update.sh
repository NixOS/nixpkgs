#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts jq curl gradle2nix

OWNER=kamax-matrix
REPO=mxisd
ATTR=mxisd

TAG=$(curl -s https://api.github.com/repos/$OWNER/$REPO/releases/latest | jq -r .tag_name)
REV=$(curl -s https://api.github.com/repos/$OWNER/$REPO/git/ref/tags/$TAG | jq -r .object.sha)
update-source-version $ATTR $REV --version-key=rev
update-source-version $ATTR $(echo $TAG | sed 's/^v//') --ignore-same-hash

PKG_FILE=$(nix-instantiate --eval --strict -A $ATTR.meta.position | sed -re 's/^"(.*):[0-9]+"$/\1/')
PKG_DIR=$(dirname $PKG_FILE)

TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR;" EXIT
cd $TMPDIR

git clone https://github.com/$OWNER/$REPO
cd $REPO
git checkout $REV

gradle2nix
cp gradle-env.json $PKG_DIR/
