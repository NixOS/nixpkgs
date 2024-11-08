#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl wget jq yq common-updater-scripts prefetch-yarn-deps yarn-lock-converter

set -eu -o pipefail

TMPDIR=/tmp/pgadmin-update-script

################################################################
#         This script will update pgadmin4 in nixpkgs          #
# Due to recent changes upstream, we will need to convert the  #
#             `yarn.lock` file back to version 1.              #
#   This isn't trivially done and relies on 3rd party tools    #
#       and a hand-written converter (in this script).         #
# Also, the converter cannot check for `github` repos in the   #
#   `yarn.lock` file, which this script will add automatically #
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

printf "Will now convert the v2 lockfile. This will download the npm packages to get the metadata.\n"
printf "Please note: This will take some time! For details, see the logfile ${TMPDIR}/update.log\n"
yarn-lock-converter -i yarn.lock -o yarn_v1.lock --cache .cache > $TMPDIR/update.log
printf "Conversion done\n"

printf "Will now do some regex substitution post-processing\n"
sed -i -E "s|(.), |\1\", \"|g" yarn_v1.lock
sed -i -E "s|npm:||g" yarn_v1.lock
printf "Substituion done\n"

printf "Will now add missing github packages back to the v1 yarn.lock file\n"
# remove header
tail +8 yarn.lock > yarn_mod.lock
LENGTH=$(yq '. | with_entries(select(.value.resolution | contains("github"))) | keys | length' yarn_mod.lock)
for i in $(seq 0 $(($LENGTH-1)));
do
  ENTRY=$(yq ". | with_entries(select(.value.resolution | contains(\"github\"))) | keys | .[$i]" yarn_mod.lock)
  URL=$(echo $ENTRY | cut -d "@" -f 2)
  VERSION=$(yq ".$ENTRY.version" yarn_mod.lock)
  LENGTH_DEP=$(yq ".$ENTRY.dependencies | keys | length" yarn_mod.lock)
  echo "$ENTRY:" >> adendum.lock
  echo "  version $VERSION" >> adendum.lock
  echo "  resolved \"$URL" >> adendum.lock
  echo "  dependencies:" >> adendum.lock

  for j in $(seq 0 $(($LENGTH_DEP-1)));
  do
    DEPENDENCY_KEY=$(yq ".$ENTRY.dependencies | keys | .[$j]" yarn_mod.lock)
    DEPENDENCY_VALUE=$(yq ".$ENTRY.dependencies.$DEPENDENCY_KEY" yarn_mod.lock)
    # remove '"'
    DEPENDENCY_KEY=${DEPENDENCY_KEY//\"}
    echo "    \"$DEPENDENCY_KEY\" $DEPENDENCY_VALUE" >> adendum.lock
  done
done

echo "" >> yarn_v1.lock
cat adendum.lock >> yarn_v1.lock
printf "Done\n"

rm yarn.lock
mv yarn_v1.lock yarn.lock

printf "Will now generate the hash. This will download the packages to the nix store and also take some time\n"
YARN_HASH=$(prefetch-yarn-deps yarn.lock)
YARN_HASH=$(nix hash to-sri --type sha256 "$YARN_HASH")
printf "Done\n"

printf "Copy files to nixpkgs\n"
cp yarn.lock "$nixpkgs/pkgs/tools/admin/pgadmin/"
printf "Done\n"
popd

sed -i -E -e "s#yarnHash = \".*\"#yarnHash = \"$YARN_HASH\"#" ${scriptDir}/default.nix

update-source-version pgadmin4 "$newest_version" --print-changes
touch $TMPDIR/.done
