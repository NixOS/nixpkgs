#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodePackages.bower2nix curl.bin git.out jq.out

set -euo pipefail
IFS=$'\n\t'

# set -x

REPO=sensu/uchiwa

VERSION=$(curl https://api.github.com/repos/${REPO}/tags -s | jq '.[0]' -r | jq .name -r)

t=$(mktemp)

echo "Updating to: ${VERSION}"

curl https://raw.githubusercontent.com/${REPO}/${VERSION}/bower.json -s > $t
bower2nix $t bower-packages.nix

pushd $(git rev-parse --show-toplevel)
sha=$(nix-prefetch-url -A uchiwa.src)
popd

cat <<_EOF > src.nix
{
  version = "${VERSION}";
  sha256  = "${sha}";
}
_EOF

rm $t
