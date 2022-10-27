#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq nix nix-prefetch-git patchutils
set -euo pipefail

info() {
    if [ -t 2 ]; then
        set -- '\033[32m%s\033[39m\n' "$@"
    else
        set -- '%s\n' "$@"
    fi
    printf "$@" >&2
}

nitter_old_version=$(nix-instantiate --eval --strict --json -A nitter.version . | jq -r .)
nitter_old_rev=$(nix-instantiate --eval --strict --json -A nitter.src.rev . | jq -r .)
today=$(LANG=C date -u +'%Y-%m-%d')

# use latest commit before today, we should not call the version *today*
# because there might still be commits coming
# use the day of the latest commit we picked as version
commit=$(curl -Sfs "https://api.github.com/repos/zedeus/nitter/compare/$nitter_old_rev~1...master" \
    | jq '.commits | map(select(.commit.committer.date < $today) | {sha, date: .commit.committer.date}) | .[-1]' --arg today "$today")
nitter_new_rev=$(jq -r '.sha' <<< "$commit")
nitter_new_version="unstable-$(jq -r '.date[0:10]' <<< "$commit")"
info "latest commit before $today: $nitter_new_rev ($(jq -r '.date' <<< "$commit"))"

if [ "$nitter_new_rev" = "$nitter_old_rev" ]; then
    info "nitter is up-to-date."
    exit
fi

if curl -Sfs "https://github.com/zedeus/nitter/compare/$nitter_old_rev...$nitter_new_rev.patch" \
| lsdiff | grep -Fxe 'a/nitter.nimble' -e 'b/nitter.nimble' > /dev/null; then
    info "nitter.nimble changed, some dependencies probably need updating."
fi

nitter_new_sha256=$(nix-prefetch-git --rev "$nitter_new_rev" "https://github.com/zedeus/nitter.git" | jq -r .sha256)
update-source-version nitter "$nitter_new_version" "$nitter_new_sha256" --rev="$nitter_new_rev"
git commit --all --verbose --message "nitter: $nitter_old_version -> $nitter_new_version"
info "Updated nitter to $nitter_new_version."
