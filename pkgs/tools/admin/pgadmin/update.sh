#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl wget jq common-updater-scripts yarn-berry_4 yarn-berry_4.yarn-berry-fetcher

set -eu -o pipefail

TMPDIR=/tmp/pgadmin-update-script

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
patch -u yarn.lock ${scriptDir}/mozjpeg.patch

printf "Will now generate the hash. This will download the packages to the nix store and also take some time\n"
yarn-berry-fetcher missing-hashes yarn.lock
if [[ -f missing-hashes.json ]]; then
  YARN_HASH=$(yarn-berry-fetcher prefetch yarn.lock missing-hashes.json)
else
  YARN_HASH=$(yarn-berry-fetcher prefetch yarn.lock)
fi
printf "Done\n"

if [[ -f missing-hashes.json ]]; then
  if [[ ! -f "$nixpkgs/pkgs/tools/admin/pgadmin/missing-hashes.json" ]]; then
    printf "PLEASE NOTE: FIRST TIME OF FINDING MISSING HASHES!"
    printf "Please add \"missingHashes = ./missing-hashes.json\" to pgadmin derivation"
  fi
  printf "Copy files to nixpkgs\n"
  cp missing-hashes.json "$nixpkgs/pkgs/tools/admin/pgadmin/"
fi

printf "Done\n"
popd

sed -i -E -e "s#yarnHash = \".*\"#yarnHash = \"$YARN_HASH\"#" ${scriptDir}/default.nix

update-source-version pgadmin4 "$newest_version" --print-changes
touch $TMPDIR/.done
