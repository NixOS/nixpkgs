#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts git jq nix nix-prefetch-git
git_url='https://github.com/unode/firefox_decrypt.git'
git_branch='master'
git_dir='/var/tmp/firefox_decrypt.git'
nix_file="$(dirname "${BASH_SOURCE[0]}")/default.nix"
pkg='firefox_decrypt'

set -euo pipefail

info() {
    if [ -t 2 ]; then
        set -- '\033[32m%s\033[39m\n' "$@"
    else
        set -- '%s\n' "$@"
    fi
    printf "$@" >&2
}

old_rev=$(nix-instantiate --eval --strict --json -A "$pkg.src.rev" | jq -r)
old_version=$(nix-instantiate --eval --strict --json -A "$pkg.version" | jq -r)
today=$(LANG=C date -u +'%Y-%m-%d')

info "fetching $git_url..."
if [ ! -d "$git_dir" ]; then
    git init --initial-branch="$git_branch" "$git_dir"
    git -C "$git_dir" remote add origin "$git_url"
fi
git -C "$git_dir" fetch origin "$git_branch"

# use latest commit before today, we should not call the version *today*
# because there might still be commits coming
# use the day of the latest commit we picked as version
new_rev=$(git -C "$git_dir" log -n 1 --format='format:%H' --before="${today}T00:00:00Z" "origin/$git_branch")
new_version="unstable-$(git -C "$git_dir" log -n 1 --format='format:%cs' "$new_rev")"
info "latest commit before $today: $new_rev"

if [ "$new_rev" = "$old_rev" ]; then
    info "$pkg is up-to-date."
    exit
fi

new_sha256=$(nix-prefetch-git --rev "$new_rev" "$git_dir" | jq -r .sha256)
update-source-version "$pkg" \
    "$new_version" \
    "$new_sha256" \
    --rev="$new_rev"
git add "$nix_file"
git commit --verbose --message "$pkg: $old_version -> $new_version"
