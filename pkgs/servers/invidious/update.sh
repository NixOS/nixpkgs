#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl crystal crystal2nix jq git gnused nix nix-prefetch-git nix-update pkg-config
git_url='https://github.com/iv-org/invidious.git'
git_branch='master'
git_dir='/var/tmp/invidious.git'
pkg='invidious'

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
commit_msg="$pkg: $old_version -> $new_version"

cd "$(dirname "${BASH_SOURCE[0]}")"

# fetch video.js dependencies
info "Running scripts/fetch-player-dependencies.cr..."
git -C "$git_dir" reset --hard "$new_rev"
(cd "$git_dir" && crystal run scripts/fetch-player-dependencies.cr -- --minified)
rm -f "$git_dir/assets/videojs/.gitignore"
videojs_new_sha256=$(nix hash-path --type sha256 --base32 "$git_dir/assets/videojs")
sed -e "s,\boutputHash = .*,outputHash = \"$videojs_new_sha256\";," -i 'videojs.nix'

if git -C "$git_dir" diff-tree --quiet "${old_rev}..${new_rev}" -- 'shard.lock'; then
    info "shard.lock did not change since $old_rev."
else
    info "Updating shards.nix..."
    crystal2nix -- "$git_dir/shard.lock"  # argv's index seems broken

    lsquic_old_version=$(nix-instantiate --eval --strict --json -A "${pkg}.lsquic.version" '../../..' | jq -r)
    lsquic_new_version=$(nix eval --raw -f 'shards.nix' lsquic.rev \
        | sed -e 's/^v//' -e 's/-[0-9]*$//')
    if [ "$lsquic_old_version" != "$lsquic_new_version" ]; then
        info "Updating lsquic to $lsquic_new_version..."
        nix-update --version "$lsquic_new_version" -f '../../..' invidious.lsquic
        if git diff-index --quiet HEAD -- 'lsquic.nix'; then
            info "lsquic is up-to-date."
        else
            boringssl_new_version=$(curl -LSsf "https://github.com/litespeedtech/lsquic/raw/v${lsquic_new_version}/README.md" \
                | grep -Pom1 '(?<=^git checkout ).*')
            boringssl_new_sha256=$(nix-prefetch-git --rev "$boringssl_new_version" 'https://boringssl.googlesource.com/boringssl' \
                | jq -r .sha256)
            sed -e "0,/^ *version = .*/ s//    version = \"$boringssl_new_version\";/" \
                -e "0,/^ *sha256 = .*/ s//      sha256 = \"$boringssl_new_sha256\";/" \
                -i 'lsquic.nix'
            commit_msg="$commit_msg

lsquic: $lsquic_old_version -> $lsquic_new_version"
        fi
    fi
fi

git commit --verbose --message "$commit_msg" *.nix
