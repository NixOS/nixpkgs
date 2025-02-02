#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl crystal crystal2nix jq git moreutils nix nix-prefetch pkg-config pcre gnugrep
git_url='https://github.com/iv-org/invidious.git'
git_branch='master'
git_dir='/var/tmp/invidious.git'
pkg='invidious'

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

info() {
    if [ -t 2 ]; then
        set -- '\033[32m%s\033[39m\n' "$@"
    else
        set -- '%s\n' "$@"
    fi
    printf "$@" >&2
}

json_get() {
    jq -r "$1" < 'versions.json'
}

json_set() {
    jq --arg x "$2" "$1 = \$x" < 'versions.json' | sponge 'versions.json'
}

old_version=$(json_get '.invidious.version')
today=$(LANG=C date -u +'%Y-%m-%d')

info "fetching $git_url..."
if [ ! -d "$git_dir" ]; then
    git init --initial-branch="$git_branch" "$git_dir"
    git -C "$git_dir" remote add origin "$git_url"
fi
git -C "$git_dir" fetch origin --tags "$git_branch"

new_tag="$(git -C "$git_dir" ls-remote --tags --sort=committerdate origin | head -n1 | grep -Po '(?<=refs/tags/).*')"
new_version="${new_tag#v}"

if [ "$new_version" = "$old_version" ]; then
    info "$pkg is up-to-date."
    exit
fi

commit="$(git -C "$git_dir" rev-list "$new_tag" --max-count=1 --abbrev-commit)"
date="$(git -C "$git_dir" log -1 --format=%cd --date=format:%Y.%m.%d)"
json_set '.invidious.date' "$date"
json_set '.invidious.commit' "$commit"
json_set '.invidious.version' "$new_version"

new_hash=$(nix-prefetch -I 'nixpkgs=../../..' "$pkg")
json_set '.invidious.hash' "$new_hash"

# fetch video.js dependencies
info "Running scripts/fetch-player-dependencies.cr..."
git -C "$git_dir" reset --hard "$new_tag"
(cd "$git_dir" && crystal run scripts/fetch-player-dependencies.cr -- --minified)
rm -f "$git_dir/assets/videojs/.gitignore"
videojs_new_hash=$(nix-hash --type sha256 --sri "$git_dir/assets/videojs")
json_set '.videojs.hash' "$videojs_new_hash"

if git -C "$git_dir" diff-tree --quiet "v${old_version}..${new_tag}" -- 'shard.lock'; then
    info "shard.lock did not change since v$old_version."
else
    info "Updating shards.nix..."
    (cd "$git_dir" && crystal2nix)
    mv "$git_dir/shards.nix" .
fi
