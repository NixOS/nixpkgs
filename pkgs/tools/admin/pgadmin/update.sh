#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl wget jq yq common-updater-scripts prefetch-yarn-deps yarn-lock-converter

set -eu -o pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

################################################################
#         This script will update pgadmin4 in nixpkgs          #
# Due to recent changes upstream, we will need to convert the  #
#             `yarn.lock` file back to version 1.              #
#   This isn't trivially done and relies on 3rd party tools    #
#       and a hand-written converter (in this script).         #
# Also, the converter cannot check for `github` repos in the   #
#   `yarn.lock` file, which this script will add automatically #
################################################################



##################################################
# Check for new version and download #
##################################################

scriptDir=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
nixpkgs=$(realpath "$scriptDir"/../../../..)

newest_version="$(curl -s https://www.pgadmin.org/versions.json | jq -r .pgadmin4.version)"
old_version=$(nix-instantiate --eval -E "(import \"$nixpkgs\" { config = {}; overlays = []; }).pgadmin4.version" | tr -d '"')
url="https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${newest_version}/source/pgadmin4-${newest_version}.tar.gz"

if [[ $newest_version == $old_version ]]; then
  printf "${GREEN}Already at latest version $newest_version${NC}\n"
  exit 0
fi
printf "${YELLOW}New version: $newest_version ${NC}\n"

# don't use mktemp, so if a network error happens, we can resume from there
mkdir -p /tmp/pgadmin-update-script
pushd /tmp/pgadmin-update-script
wget -nc $url
tar -xzf "pgadmin4-$newest_version.tar.gz"
cd "pgadmin4-$newest_version/web"


######################################
# Convert the `yarn.lock` file to v1 #
######################################

printf "${YELLOW}Will now convert the v2 lockfile. This will download the npm packages to get the metadata.\n"
printf "Please note: This will take some time!${NC}\n"
yarn-lock-converter -i yarn.lock -o yarn_v1.lock --cache .cache
printf "${GREEN}Conversion done${NC}\n"

###########################################################################
# Do some post-convert corrections (namely add '"' to multipackage lines) #
###########################################################################

printf "${YELLOW}Will now do some regex substitution post-processing${NC}\n"
sed -i -E "s|(.), |\1\", \"|g" yarn_v1.lock
printf "${GREEN}Substituion done${NC}\n"

#########################################################
# Add the github packages we lost during the conversion #
#########################################################

printf "${YELLOW}Will now add missing github packages back to the v1 yarn.lock file${NC}\n"
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
printf "${GREEN}Done${NC}\n"

###########
# cleanup #
###########

rm yarn.lock adendum.lock
mv yarn_v1.lock yarn.lock

##############################
# Generate correct yarn hash #
##############################

printf "${YELLOW}Will now generate the hash. This will download the packages to the nix store and also take some time${NC}\n"
YARN_HASH=$(prefetch-yarn-deps yarn.lock)
YARN_HASH=$(nix hash to-sri --type sha256 "$YARN_HASH")
printf "${GREEN}Done${NC}\n"

##########################################
# add the v1 `yarn.lock` file to nixpkgs #
##########################################

printf "${YELLOW}Copy files to nixpkgs${NC}\n"
cp yarn.lock "$nixpkgs/pkgs/tools/admin/pgadmin/"
printf "${GREEN}Done${NC}\n"
popd
rm -rf /tmp/pgadmin-update-script

#############################################
# Update the hashes in the default.nix file #
#############################################

sed -i -E -e "s#yarnSha256 = \".*\"#yarnSha256 = \"$YARN_HASH\"#" ${scriptDir}/default.nix

update-source-version pgadmin4 "$newest_version" --print-changes
