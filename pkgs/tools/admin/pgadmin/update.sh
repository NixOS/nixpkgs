#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl wget jq yarn2nix yarn common-updater-scripts

set -eu -o pipefail

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../..)

newest_version="$(curl -s https://www.pgadmin.org/versions.json | jq -r .pgadmin4.version)"
old_version=$(nix-instantiate --eval -E "(import \"$nixpkgs\" { config = {}; overlays = []; }).pgadmin4.version" | tr -d '"')
url="https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${newest_version}/source/pgadmin4-${newest_version}.tar.gz"

if [[ $newest_version == $old_version ]]; then
  echo "Already at latest version $newest_version"
  exit 0
fi
echo "New version: $newest_version"

pushd $(mktemp -d --suffix=-pgadmin4-updater)
wget $url
tar -xzf "pgadmin4-$newest_version.tar.gz"
cd "pgadmin4-$newest_version/web"
yarn2nix > yarn.nix
cp yarn.nix yarn.lock package.json "$nixpkgs/pkgs/tools/admin/pgadmin/"
popd

update-source-version pgadmin4 "$newest_version" --print-changes
