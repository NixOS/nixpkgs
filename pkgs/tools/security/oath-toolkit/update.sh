#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl git gnugrep nix

set -euo pipefail

nixfile='default.nix'
release_url='https://download.savannah.nongnu.org/releases/oath-toolkit/'
attr='oath-toolkit'
command='oathtool --version'

color() {
    printf '%s: \033[%sm%s\033[39m\n' "$0" "$1" "$2" >&2 || true
}

color 32 "downloading $release_url..."
if ! release_page=$(curl -Lf "$release_url"); then
    color 31 "cannot download release page"
    exit 1
fi

tarball_name=$(printf '%s\n' "$release_page" \
    | grep -Po '(?<=href=").*?\.tar\.gz(?=")' \
    | sort -n | tail -n1)
tarball_version="${tarball_name%.tar.*}"
tarball_version="${tarball_version##*-}"
tarball_url="mirror://savannah${release_url#https://*/releases}$tarball_name"

color 32 "nix-prefetch-url $tarball_url..."
if ! tarball_sha256=$(nix-prefetch-url --type sha256 "$tarball_url"); then
    color 31 "cannot prefetch $tarball_url"
    exit 1
fi

old_version=$(grep -Pom1 '(?<=version = ").*?(?=";)' "$nixfile")

version=$(printf 'version = "%s";\n' "$tarball_version")
sha256=$(printf 'sha256 = "%s";\n' "$tarball_sha256")
sed -e "s,version = .*,$version," -e "s,sha256 = .*,$sha256," -i "$nixfile"

if git diff --exit-code "$nixfile" > /dev/stderr; then
    printf '\n' >&2 || true
    color 32 "$tarball_version is up to date"
else
    color 32 "running '$command' with nix-shell..."
    nix-shell -p "callPackage ./$nixfile {}" --run "$command"
    msg="$attr: $old_version -> $tarball_version"
    printf '\n' >&2 || true
    color 31 "$msg"
    git commit -m "$msg" "$nixfile"
fi
