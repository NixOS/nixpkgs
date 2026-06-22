#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -euo pipefail

package=beatoraja.passthru.jportaudio

repo=$(nix-instantiate --eval -A $package.src.owner --json | jq -r .)/$(nix-instantiate --eval -A $package.src.repo --json | jq -r .)
response=$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL "https://api.github.com/repos/$repo/commits?per_page=1")
rev=$(echo "$response" | jq -r '.[0].sha')
date=$(echo "$response" | jq -r '.[0].commit.committer.date' | cut -c1-10)
release=$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL "https://api.github.com/repos/$repo/releases?per_page=1" | jq -r '.[0].tag_name')
if [[ $release == null ]]; then release=0; fi
if [[ $release == v* ]]; then release=${release#v}; fi
if [[ $release == build* ]]; then release=${release#build}; fi
update-source-version $package $release-unstable-$date --rev=$rev
