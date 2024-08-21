#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-scripts

set -eou pipefail

version=$1

linux_bucket="https://download.pytorch.org/whl"

url_and_key_list=(
  "x86_64-linux-38 $linux_bucket/triton-${version}-0-cp38-cp38-manylinux2014_x86_64.manylinux_2_17_x86_64.whl triton-${version}-cp38-cp38-linux_x86_64.whl"
  "x86_64-linux-39 $linux_bucket/triton-${version}-0-cp39-cp39-manylinux2014_x86_64.manylinux_2_17_x86_64.whl triton-${version}-cp39-cp39-linux_x86_64.whl"
  "x86_64-linux-310 $linux_bucket/triton-${version}-0-cp310-cp310-manylinux2014_x86_64.manylinux_2_17_x86_64.whl triton-${version}-cp310-cp310-linux_x86_64.whl"
  "x86_64-linux-311 $linux_bucket/triton-${version}-0-cp311-cp311-manylinux2014_x86_64.manylinux_2_17_x86_64.whl triton-${version}-cp311-cp311-linux_x86_64.whl"
)

hashfile=binary-hashes-"$version".nix
echo "  \"$version\" = {" >> $hashfile

for url_and_key in "${url_and_key_list[@]}"; do
  key=$(echo "$url_and_key" | cut -d' ' -f1)
  url=$(echo "$url_and_key" | cut -d' ' -f2)
  name=$(echo "$url_and_key" | cut -d' ' -f3)

  echo "prefetching ${url}..."
  hash=$(nix hash to-sri --type sha256 `nix-prefetch-url "$url" --name "$name"`)

  cat << EOF >> $hashfile
    $key = {
      name = "$name";
      url = "$url";
      hash = "$hash";
    };
EOF

  echo
done

echo "  };" >> $hashfile
echo "done."
