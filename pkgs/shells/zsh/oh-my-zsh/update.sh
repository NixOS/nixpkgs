#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts jq

set -eu -o pipefail

oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion oh-my-zsh" | tr -d '"')"
latestSha="$(curl -L -s https://api.github.com/repos/robbyrussell/oh-my-zsh/commits\?sha\=master\&since\=${oldVersion} | jq -r '.[0].sha')"
url="$(nix-instantiate --eval -E "with import ./. {}; oh-my-zsh.src.url" | tr -d '"')"

if [ ! "null" = "${latestSha}" ]; then
  latestDate="$(curl -L -s https://api.github.com/repos/robbyrussell/oh-my-zsh/commits/${latestSha} | jq '.commit.author.date' | sed 's|"\(.*\)T.*|\1|g')"
  update-source-version oh-my-zsh "${latestSha}" --version-key=rev
  update-source-version oh-my-zsh "${latestDate}" --ignore-same-hash
  nixpkgs="$(git rev-parse --show-toplevel)"
  default_nix="$nixpkgs/pkgs/shells/zsh/oh-my-zsh/default.nix"
  git add "${default_nix}"
  git commit -m "oh-my-zsh: ${oldVersion} -> ${latestDate}"
else
  echo "oh-my-zsh is already up-to-date"
fi
