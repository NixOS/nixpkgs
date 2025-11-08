#!/usr/bin/env bash
set -euo pipefail

# To update all rt kernels run: ./update-rt.sh

# To update just one ./linux-rt-5.X.nix run: ./update-rt.sh ./linux-rt-5.X.nix

# To add a new kernel branch 5.Y run: ./update-rt.sh ./linux-rt-5.Y.nix
# (with nonexistent .nix file) and update all-packages.nix.

# To commit run with: env COMMIT=1

mirror=https://kernel.org/pub/linux/kernel

main() {
    if [ $# -ge 1 ]; then
        update-if-needed "$1"
    else
        update-all-if-needed
    fi
}

update-all-if-needed() {
    for f in "$(dirname "$0")"/linux-rt-*.nix; do
        update-if-needed "$f"
    done
}

file-version() {
    file="$1" # e.g. ./linux-rt-5.4.nix
    if [ -e "$file" ]; then
        grep ' version = ' "$file" | grep -o '[0-9].[^"]*'
    fi
}

latest-rt-version() {
    branch="$1" # e.g. 5.4
    curl -sL "$mirror/projects/rt/$branch/sha256sums.asc" |
        sed -ne '/.patch.xz/ { s/.*patch-\(.*\).patch.xz/\1/p}' |
        grep -v '\-rc' |
        sort --version-sort |
        tail -n 1
}

update-if-needed() {
    file="$1" # e.g. ./linux-rt-5.4.nix (created if does not exist)
    branch=$(basename "$file" .nix) # e.g. linux-rt-5.4
    branch=${branch#linux-rt-} # e.g. 5.4
    cur=$(file-version "$file") # e.g. 5.4.59-rt36 or empty
    new=$(latest-rt-version "$branch") # e.g. 5.4.61-rt37
    kversion=${new%-*} # e.g. 5.4.61
    major=${branch%.*} # e.g 5
    nixattr="linux-rt_${branch/./_}"
    if [ "$new" = "$cur" ]; then
        echo "$nixattr: $cur (up-to-date)"
        return
    fi
    khash=$(nix-prefetch-url "$mirror/v${major}.x/linux-${kversion}.tar.xz" | nix-hash --type sha256 --to-sri)
    phash=$(nix-prefetch-url "$mirror/projects/rt/${branch}/older/patch-${new}.patch.xz" | nix-hash --type sha256 --to-sri)
    if [ "$cur" ]; then
        msg="$nixattr: $cur -> $new"
    else
        msg="$nixattr: init at $new"
        prev=$(ls -v "$(dirname "$0")"/linux-rt-*.nix | tail -1)
        cp "$prev" "$file"
        cur=$(file-version "$file")
    fi
    echo "$msg"
    sed -i "$file" \
        -e "s/$cur/$new/" \
        -e "s|kernel/v[0-9]*|kernel/v$major|" \
        -e "1,/.patch.xz/ s|hash = .*|hash = \"$khash\";|" \
        -e "1,/.patch.xz/! s|hash = .*|hash = \"$phash\";|"
    if [ "${COMMIT:-}" ]; then
        git add "$file"
        git commit -m "$msg"
    fi
}

return 2>/dev/null || main "$@"
