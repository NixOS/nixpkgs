#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p nix cacert git getopt
# shellcheck shell=bash

if [ ! -d .git ]; then
  echo "This script needs to be run from the root directory of nixpkgs. Exiting."
  exit 1
fi

pkg_dir="$(dirname "$0")"

src="$(nix-build . --no-out-link -A coreboot-toolchain.src)"
urls=$($src/util/crossgcc/buildgcc -u)

tmp=$(mktemp)
echo '{ fetchurl }: [' > $tmp

for url in $urls; do
  name="$(basename $url)"
  hash="$(nix-prefetch-url "$url")"

  cat << EOF >> $tmp
  {
    name = "$name";
    archive = fetchurl {
      sha256 = "$hash";
      url = "$url";
    };
  }
EOF
done

echo ']' >> $tmp

sed -ie 's/https\:\/\/ftpmirror\.gnu\.org/mirror\:\/\/gnu/g' $tmp

mv $tmp $pkg_dir/sources.nix
