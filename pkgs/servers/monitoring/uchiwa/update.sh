#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl.bin git.out jq.out nodePackages.bower2nix

set -euo pipefail
IFS=$'\n\t'

# set -x

REPO=sensu/uchiwa
SHA="1111111111111111111111111111111111111111111111111111"

write_src() {
  cat <<_EOF > src.nix
{
  version = "${VERSION}";
  sha256  = "${SHA}";
}
_EOF
}

t=$(mktemp -d)

LATEST_VERSION=$(curl https://api.github.com/repos/${REPO}/tags -s | jq '.[0]' -r | jq .name -r)
echo "Latest version: ${LATEST_VERSION}"

VERSION=${1:-${LATEST_VERSION}}
echo "Updating to: ${VERSION}"

write_src

curl https://raw.githubusercontent.com/${REPO}/${VERSION}/bower.json -s > $t/bower.json
bower2nix $t/bower.json $t/bower-packages.nix
mv $t/bower-packages.nix .
# sed -i 's@/@-@g' bower-packages.nix

pushd $(git rev-parse --show-toplevel)
SHA=$(nix-prefetch-url -A uchiwa.src)
popd

write_src

rm -r $t
