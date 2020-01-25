#!/bin/sh
set -e

URL=https://github.com/tootsuite/mastodon.git

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        --url)
        URL="$2"
        shift # past argument
        shift # past value
        ;;
        --ver)
        VERSION="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        POSITIONAL+=("$1")
        shift # past argument
        ;;
    esac
done

if [[ -z "$VERSION" || -n "$POSITIONAL" ]]; then
    echo "Usage: update.sh [--url URL] --ver VERSION"
    echo "URL may be any path acceptable to 'git clone' and VERSION any revision"
    echo "acceptable to 'git checkout'.  If URL is not provided, it defaults"
    echo "to https://github.com/tootsuite/mastodon.git."
    exit 1
fi

rm -f gemset.nix yarn.nix version.nix source.nix package.json
TARGET_DIR="$PWD"


WORK_DIR=$(mktemp -d)

# Check that working directory was created.
if [[ ! "$WORK_DIR" || ! -d "$WORK_DIR" ]]; then
  echo "Could not create temporary directory"
  exit 1
fi

# Delete the working directory on exit.
function cleanup {
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT

echo "Fetching source code from $URL"
JSON=$(nix-prefetch-git --url "$URL" --rev "$VERSION" --quiet)
SHA=$(echo $JSON | jq -r .sha256)

echo "Creating version.nix"
echo \"$VERSION\" | sed 's/^"v/"/' > version.nix

echo "Creating source.nix"
# yarn2nix and mkYarnPackage want the version to be present in
# package.json. Mastodon itself does not include the version in
# package.json but at least one fork (Soapbox) does.
cat > source.nix << EOF
{ fetchgit, runCommand, jq }: let
  src = fetchgit {
    url = "$URL";
    rev = "$VERSION";
    sha256 = "$SHA";
  };
  version = import ./version.nix;
in runCommand "mastodon-source" { buildInputs = [ jq ]; } ''
  cp -r \${src} \$out
  chmod -R u+w \$out
  if [ \$(jq .version \${src}/package.json) == "null" ]; then
    jq ". + {version: \"\${version}\"}" \${src}/package.json > \$out/package.json
  fi
''
EOF

SOURCE_DIR="$(nix-build --no-out-link -E '(import <nixpkgs> {}).callPackage ./source.nix {}')"

echo "Creating gemset.nix"
bundix --lockfile="$SOURCE_DIR/Gemfile.lock" --gemfile="$SOURCE_DIR/Gemfile"

echo "Creating yarn.nix"
cp -r $SOURCE_DIR/* $WORK_DIR
chmod -R u+w $WORK_DIR
cd $WORK_DIR
yarn2nix > $TARGET_DIR/yarn.nix
sed "s/https___.*_//g" -i $TARGET_DIR/yarn.nix
cp $WORK_DIR/package.json $TARGET_DIR
