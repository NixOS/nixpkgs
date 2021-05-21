#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq nix-prefetch-git yarn yarn2nix-moretea.yarn2nix moreutils

# NOTE: please check on new releases which steps aren't necessary anymore!
# Currently the following things are done:
#
# * Add correct `name`/`version` field to `package.json`, otherwise `yarn2nix` fails to
#   find required dependencies.
# * Keep `tailwindcss` on version 2.0.1-compat (on `yarn` it will be upgraded due to the `^`).
#   This is needed to make sure the entire build still works with `postcss-7` (needed
#   by plausible).
# * Adjust `file:`-dependencies a bit for the structure inside a Nix build.
# * Update hashes for the tarball & the fixed-output drv with all `mix`-dependencies.
# * Generate `yarn.lock` & `yarn.nix` in a temporary directory.

set -x

dir="$(realpath $(dirname "$0"))"
latest="$(curl -q https://api.github.com/repos/plausible/analytics/releases/latest \
  | jq -r '.tag_name')"
nix_version="$(cut -c2- <<< "$latest")"

if [ "$(nix-instantiate -A plausible.version --eval | xargs echo)" = "$nix_version" ];
then
  echo "Already using version $latest, skipping"
  exit 0
fi

SRC="https://raw.githubusercontent.com/plausible/analytics/${latest}"

package_json="$(curl -qf "$SRC/assets/package.json")"
fixed_tailwind_version="$(jq '.dependencies.tailwindcss' -r <<< "$package_json" | sed -e 's,^^,,g')"

echo "$package_json" \
  | jq '. + {"name":"plausible","version":"'$latest'"}' \
  | jq '.dependencies.tailwindcss = "'"$fixed_tailwind_version"'"' \
  | sed -e 's,../deps/,../../tmp/deps/,g' \
  > $dir/package.json

tarball_meta="$(nix-prefetch-git https://github.com/plausible/analytics --rev "$latest" --quiet)"
tarball_hash="$(jq -r '.sha256' <<< "$tarball_meta")"
tarball_path="$(jq -r '.path' <<< "$tarball_meta")"
fake_hash="$(nix-instantiate --eval -A lib.fakeSha256 | xargs echo)"

sed -i "$dir/default.nix" \
  -e 's,version = ".*",version = "'"$nix_version"'",' \
  -e '/^  src = fetchFromGitHub/,+4{;s/sha256 = "\(.*\)"/sha256 = "'"$tarball_hash"'"/}' \
  -e '/^  mixDeps =/,+3{;s/sha256 = "\(.*\)"/sha256 = "'"$fake_hash"'"/}'

mix_hash="$(nix-build -A plausible.mixDeps 2>&1 | tail -n3 | grep 'got:' | cut -d: -f2- | xargs echo)"

sed -i "$dir/default.nix" -e '/^  mixDeps =/,+3{;s/sha256 = "\(.*\)"/sha256 = "'"$mix_hash"'"/}'

tmp_setup_dir="$(mktemp -d)"
trap "rm -rf $tmp_setup_dir" EXIT

cp -r $tarball_path/* $tmp_setup_dir/
cp -r "$(nix-build -A plausible.mixDeps)" "$tmp_setup_dir/deps"
chmod -R a+rwx "$tmp_setup_dir"

pushd $tmp_setup_dir/assets
jq < package.json '.dependencies.tailwindcss = "'"$fixed_tailwind_version"'"' | sponge package.json
yarn
yarn2nix > "$dir/yarn.nix"
cp yarn.lock "$dir/yarn.lock"
popd

nix-build -A plausible
