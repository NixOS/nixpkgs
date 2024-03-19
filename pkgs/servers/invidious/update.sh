#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl crystal crystal2nix jq git moreutils nix nix-prefetch pkg-config pcre
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

old_rev=$(json_get '.invidious.rev')
old_version=$(json_get '.invidious.version')
today=$(LANG=C date -u +'%Y-%m-%d')

info "fetching $git_url..."
if [ ! -d "$git_dir" ]; then
    git init --initial-branch="$git_branch" "$git_dir"
    git -C "$git_dir" remote add origin "$git_url"
fi
git -C "$git_dir" fetch origin --tags "$git_branch"

# use latest commit before today, we should not call the version *today*
# because there might still be commits coming
# use the day of the latest commit we picked as version
new_rev=$(git -C "$git_dir" log -n 1 --format='format:%H' --before="${today}T00:00:00Z" "origin/$git_branch")
new_tag=$(git -C "$git_dir" describe --tags --abbrev=0 "$new_rev")
new_version="$new_tag-unstable-$(TZ=UTC git -C "$git_dir" log -n 1 --date='format-local:%Y-%m-%d' --format='%cd' "$new_rev")"
info "latest commit before $today: $new_rev"

if [ "$new_rev" = "$old_rev" ]; then
    info "$pkg is up-to-date."
    exit
fi

json_set '.invidious.version' "$new_version"
json_set '.invidious.rev' "$new_rev"
new_hash=$(nix-prefetch -I 'nixpkgs=../../..' "$pkg")
json_set '.invidious.hash' "$new_hash"
commit_msg="$pkg: $old_version -> $new_version"

# fetch video.js dependencies
info "Running scripts/fetch-player-dependencies.cr..."
git -C "$git_dir" reset --hard "$new_rev"
(cd "$git_dir" && crystal run scripts/fetch-player-dependencies.cr -- --minified)
rm -f "$git_dir/assets/videojs/.gitignore"
videojs_new_hash=$(nix-hash --type sha256 --sri "$git_dir/assets/videojs")
json_set '.videojs.hash' "$videojs_new_hash"

if git -C "$git_dir" diff-tree --quiet "${old_rev}..${new_rev}" -- 'shard.lock'; then
    info "shard.lock did not change since $old_rev."
else
    info "Updating shards.nix..."
    crystal2nix -- "$git_dir/shard.lock"  # argv's index seems broken
fi

git commit --verbose --message "$commit_msg" -- versions.json shards.nix
