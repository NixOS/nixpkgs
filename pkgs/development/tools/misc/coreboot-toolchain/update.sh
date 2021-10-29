#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p nix cacert git getopt

rootdir="../../../../../"

src="$(nix-build $rootdir --no-out-link -A coreboot-toolchain.src)"
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

mv $tmp sources.nix
