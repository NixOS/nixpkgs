#! /usr/bin/env nix-shell
#! nix-shell -i oil -p oil jq sd nix-prefetch-github ripgrep moreutils

# TODO set to `verbose` or `extdebug` once implemented in oil
shopt --set xtrace
# we need failures inside of command subs to get the correct dependency sha256
shopt --unset inherit_errexit

const directory = $(dirname $0 | xargs realpath)
const owner = "LemmyNet"
const ui_repo = "lemmy-ui"
const server_repo = "lemmy"
const latest_rev = $(curl -q https://api.github.com/repos/${owner}/${server_repo}/releases/latest | \
  jq -r '.tag_name')
const latest_version = $(echo $latest_rev)
const current_version = $(jq -r '.version' $directory/pin.json)
if ($latest_version === $current_version) {
  echo "lemmy is already up-to-date"
  return 0
} else {
  # for some strange reason, hydra fails on reading upstream package.json directly
  const source = "https://raw.githubusercontent.com/$owner/$ui_repo/$latest_version"
  const package_json = $(curl -qf $source/package.json)
  echo $package_json > $directory/package.json

  const server_tarball_meta = $(nix-prefetch-github $owner $server_repo --rev $latest_rev)
  const server_tarball_hash = "sha256-$(echo $server_tarball_meta | jq -r '.sha256')"
  const ui_tarball_meta = $(nix-prefetch-github $owner $ui_repo --rev $latest_rev)
  const ui_tarball_hash = "sha256-$(echo $ui_tarball_meta | jq -r '.sha256')"

  jq ".version = \"$latest_version\" | \
      .\"serverSha256\" = \"$server_tarball_hash\" | \
      .\"uiSha256\" = \"$ui_tarball_hash\" | \
      .\"serverCargoSha256\" = \"\" | \
      .\"uiYarnDepsSha256\" = \"\"" $directory/pin.json | sponge $directory/pin.json

  const new_cargo_sha256 = $(nix-build -A lemmy-server 2>&1 | \
    tail -n 2 | \
    head -n 1 | \
    sd '\s+got:\s+' '')

  const new_offline_cache_sha256 = $(nix-build -A lemmy-ui 2>&1 | \
    tail -n 2 | \
    head -n 1 | \
    sd '\s+got:\s+' '')

  jq ".\"serverCargoSha256\" = \"$new_cargo_sha256\" | \
      .\"uiYarnDepsSha256\" = \"$new_offline_cache_sha256\"" \
    $directory/pin.json | sponge $directory/pin.json
}

