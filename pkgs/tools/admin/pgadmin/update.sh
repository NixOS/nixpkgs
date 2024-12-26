#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl wget jq yq common-updater-scripts yarn-berry_3

set -eu -o pipefail

TMPDIR=/tmp/pgadmin-update-script

################################################################
#         This script will update pgadmin4 in nixpkgs          #
#                                                              #
################################################################

cleanup() {
  if [ -e $TMPDIR/.done ]
  then
    rm -rf "$TMPDIR"
  else
    echo
    read -p "Script exited prematurely. Do you want to delete the temporary directory $TMPDIR ? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      rm -rf "$TMPDIR"
    fi
  fi
}

trap cleanup EXIT

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../..)

newest_version="$(curl -s https://www.pgadmin.org/versions.json | jq -r .pgadmin4.version)"
old_version=$(nix-instantiate --eval -E "(import \"$nixpkgs\" { config = {}; overlays = []; }).pgadmin4.version" | tr -d '"')
url="https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${newest_version}/source/pgadmin4-${newest_version}.tar.gz"

if [[ $newest_version == $old_version ]]; then
  printf "Already at latest version $newest_version\n"
  exit 0
fi
printf "New version: $newest_version \n"

# don't use mktemp, so if a network error happens, we can resume from there
mkdir -p $TMPDIR
pushd $TMPDIR
wget -c $url
tar -xzf "pgadmin4-$newest_version.tar.gz"
cd "pgadmin4-$newest_version/web"

export YARN_ENABLE_TELEMETRY=0
yarn config set enableGlobalCache false
yarn config set cacheFolder cache
yarn config set supportedArchitectures --json "$(cat $nixpkgs/pkgs/build-support/node/fetch-yarn-deps/yarn-berry-supported-archs.json)"

yarn install --immutable --mode skip-build
printf "Done\n"

YARN_HASH=$(nix hash path cache)
popd

sed -i -E -e "s#yarnHash = \".*\"#yarnHash = \"$YARN_HASH\"#" ${scriptDir}/default.nix

update-source-version pgadmin4 "$newest_version" --print-changes
touch $TMPDIR/.done
