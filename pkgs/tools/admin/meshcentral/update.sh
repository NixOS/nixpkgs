#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodejs yarn prefetch-yarn-deps jq rsync common-updater-scripts moreutils

set -exuo pipefail

expr_dir=$(cd "$(dirname "$0")"; pwd)
tmp=$(mktemp -dt update-meshcentral.XXXXXX)

npm show --json meshcentral > "$tmp/npm.json"
version=$(<"$tmp/npm.json" jq -r .version)
tarball=$(<"$tmp/npm.json" jq -r .dist.tarball)

prefetch=$(nix-prefetch-url --unpack --print-path "$tarball" | tr '\n' ' ')
read -r hash storePath <<<"$prefetch"
cd "$tmp"
rsync -r --chmod=u=rwX "$storePath/" package/
cd package

# Very crude way of discovering optional dependencies. These are
# fetched at runtime by stock upstream, but we don't allow that kind
# of thing in nix :)
awk <meshcentral.js "
  BEGIN { RS=\"[\n;]\" }
  match(\$0, /(modules|passport) = (\[.*\])$/, a) { print a[2] }
  match(\$0, /(modules|passport).push\(('[^']+')\)/, a) { print a[2] }
" |
    tr \' \" |
    jq --slurp '[if type == "array" then .[] else . end] | flatten' |
    # And an equally crude way of adding them to package.json. We
    # can't use yarn add here, because that will blow up on
    # dependencies which don't support the current platform. Even with
    # --optional.
    jq --slurpfile package package.json \
       '(. | map(. | capture("(?<name>@?[^@]+)(@(?<version>.+))?") | { key: .name, value: (.version // "*")}) | from_entries) as $optionalDependencies | $package | .[] | .optionalDependencies |= . + $optionalDependencies' |
    sponge package.json

# Fetch all the optional dependencies, so we have them available in
# yarn.lock/yarn.nix
yarn install --ignore-scripts

cp package.json "$expr_dir"
cp yarn.lock "$expr_dir/yarn.lock"

cd "$expr_dir/../../../.."
update-source-version meshcentral "$version" "$hash" "$tarball"

new_yarn_hash=$(prefetch-yarn-deps "$expr_dir/yarn.lock")
new_yarn_hash=$(nix-hash --type sha256 --to-sri "$new_yarn_hash")
old_yarn_hash=$(nix-instantiate --eval -A meshcentral.offlineCache.outputHash | tr -d '"')
sed -i "$expr_dir/default.nix" -e "s|\"$old_yarn_hash\"|\"$new_yarn_hash\"|"

# Only clean up if everything worked
cd /
rm -rf "$tmp"
