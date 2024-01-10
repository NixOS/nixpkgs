#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq nix-prefetch-github yarn yarn2nix-moretea.yarn2nix moreutils

# NOTE: please check on new releases which steps aren't necessary anymore!
# Currently the following things are done:
#
# * Add correct `name`/`version` field to `package.json`, otherwise `yarn2nix` fails to
#   find required dependencies.
# * Adjust `file:`-dependencies a bit for the structure inside a Nix build.
# * Update hashes for the tarball & the fixed-output drv with all `mix`-dependencies.
# * Generate `yarn.lock` & `yarn.nix` in a temporary directory.

set -euxo pipefail

dir="$(realpath $(dirname "$0"))"
export latest="$(curl -q https://api.github.com/repos/plausible/analytics/releases/latest \
  | jq -r '.tag_name')"
nix_version="$(cut -c2- <<< "$latest")"

if [[ "$(nix-instantiate -A plausible.version --eval --json | jq -r)" = "$nix_version" ]];
then
  echo "Already using version $latest, skipping"
  exit 0
fi

SRC="https://raw.githubusercontent.com/plausible/analytics/${latest}"

package_json="$(curl -qf "$SRC/assets/package.json")"

echo "$package_json" \
  | jq '. + {"name":"plausible","version": $ENV.latest}' \
  | sed -e 's,../deps/,../../tmp/deps/,g' \
  > $dir/package.json

tarball_meta="$(nix-prefetch-github plausible analytics --rev "$latest")"
tarball_hash="$(jq -r '.hash' <<< "$tarball_meta")"
tarball_path="$(nix-build -E 'with import ./. {}; { p }: fetchFromGitHub (builtins.fromJSON p)' --argstr p "$tarball_meta")"
fake_hash="$(nix-instantiate --eval -A lib.fakeHash | xargs echo)"

sed -i "$dir/default.nix" \
  -e 's,version = ".*",version = "'"$nix_version"'",' \
  -e '/^  src = fetchFromGitHub/,+4{;s#hash = "\(.*\)"#hash = "'"$tarball_hash"'"#}' \
  -e '/^  mixFodDeps =/,+3{;s#hash = "\(.*\)"#hash = "'"$fake_hash"'"#}'

mix_hash="$(nix-build -A plausible.mixFodDeps 2>&1 | tail -n3 | grep 'got:' | cut -d: -f2- | xargs echo || true)"

sed -i "$dir/default.nix" -e '/^  mixFodDeps =/,+3{;s#hash = "\(.*\)"#hash = "'"$mix_hash"'"#}'

tmp_setup_dir="$(mktemp -d)"
trap "rm -rf $tmp_setup_dir" EXIT

cp -r $tarball_path/* $tmp_setup_dir/
cp -r "$(nix-build -A plausible.mixFodDeps)" "$tmp_setup_dir/deps"
chmod -R u+rwx "$tmp_setup_dir"

pushd $tmp_setup_dir/assets
yarn
yarn2nix > "$dir/yarn.nix"
cp yarn.lock "$dir/yarn.lock"
popd

nix-build -A plausible
