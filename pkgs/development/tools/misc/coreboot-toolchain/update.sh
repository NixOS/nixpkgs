#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash update-shell.nix

set -xe

cd "$(dirname "$0")/../.."

nix-update coreboot $@

src="$(nix-build --no-out-link -A coreboot.src)"
urls=$($src/util/crossgcc/buildgcc -u)

echo '{ fetchurl }: [' > pkgs/coreboot/.files.nix.tmp

for url in $urls
do
	name="$(basename $url)"
	hash="$(nix-prefetch-url "$url")"

	cat << EOF >> pkgs/coreboot/.files.nix.tmp
  {
    name = "$name";
    archive = fetchurl {
      sha256 = "$hash";
      url = "$url";
    };
  }
EOF

done

echo ']' >> pkgs/coreboot/.files.nix.tmp
mv pkgs/coreboot/.files.nix.tmp pkgs/coreboot/files.nix
