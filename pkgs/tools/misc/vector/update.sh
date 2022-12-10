#!/usr/bin/env nix-shell
#! nix-shell -i oil -p jq sd nix-prefetch-github ripgrep

# TODO set to `verbose` or `extdebug` once implemented in oil
shopt --set xtrace
# we need failures inside of command subs to get the correct cargoSha256
shopt --unset inherit_errexit

const directory = $(dirname $0 | xargs realpath)
const owner = "vectordotdev"
const repo = "vector"
const latest_rev = $(curl -q https://api.github.com/repos/${owner}/${repo}/releases/latest | \
  jq -r '.tag_name')
const latest_version = $(echo $latest_rev | sd 'v' '')
const current_version = $(jq -r '.version' $directory/pin.json)
if ("$latest_version" === "$current_version") {
  echo "$repo is already up-to-date"
  return 0
} else {
  const tarball_meta = $(nix-prefetch-github $owner $repo --rev "$latest_rev")
  const tarball_hash = "sha256-$(echo $tarball_meta | jq -r '.sha256')"

  jq ".version = \"$latest_version\" | \
      .\"sha256\" = \"$tarball_hash\" | \
      .\"cargoSha256\" = \"\"" $directory/pin.json | sponge $directory/pin.json

  const new_cargo_sha256 = $(nix-build -A vector 2>&1 | \
    tail -n 2 | \
    head -n 1 | \
    sd '\s+got:\s+' '')

  jq ".cargoSha256 = \"$new_cargo_sha256\"" $directory/pin.json | sponge $directory/pin.json
}
