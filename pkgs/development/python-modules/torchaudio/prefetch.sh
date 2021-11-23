#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-scripts
# shellcheck shell=bash

set -eou pipefail

version=$1

bucket="https://download.pytorch.org/whl/cu113"

url_and_key_list=(
  "x86_64-linux-37 $bucket/torchaudio-${version}%2Bcu113-cp37-cp37m-linux_x86_64.whl torchaudio-${version}-cp37-cp37m-linux_x86_64.whl"
  "x86_64-linux-38 $bucket/torchaudio-${version}%2Bcu113-cp38-cp38-linux_x86_64.whl torchaudio-${version}-cp38-cp38-linux_x86_64.whl"
  "x86_64-linux-39 $bucket/torchaudio-${version}%2Bcu113-cp39-cp39-linux_x86_64.whl torchaudio-${version}-cp39-cp39-linux_x86_64.whl"
)

hashfile=binary-hashes-"$version".nix
echo "  \"$version\" = {" >> $hashfile

for url_and_key in "${url_and_key_list[@]}"; do
  key=$(echo "$url_and_key" | cut -d' ' -f1)
  url=$(echo "$url_and_key" | cut -d' ' -f2)
  name=$(echo "$url_and_key" | cut -d' ' -f3)

  echo "prefetching ${url}..."
  hash=$(nix hash to-sri --type sha256 `nix-prefetch-url "$url" --name "$name"`)

  echo "    $key = {" >> $hashfile
  echo "      name = \"$name\";" >> $hashfile
  echo "      url = \"$url\";" >> $hashfile
  echo "      hash = \"$hash\";" >> $hashfile
  echo "    };" >> $hashfile

  echo
done

echo "  };" >> $hashfile
echo "done."
