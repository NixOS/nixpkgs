#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-scripts

set -eou pipefail

version=$1

bucket="https://download.pytorch.org/whl"

url_and_key_list=(
  "x86_64-linux-310 $bucket/triton-${version}-cp310-cp310-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl triton-${version}-cp310-cp310-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
  "x86_64-linux-311 $bucket/triton-${version}-cp311-cp311-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl triton-${version}-cp311-cp311-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
  "x86_64-linux-312 $bucket/triton-${version}-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl triton-${version}-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
  "x86_64-linux-313 $bucket/triton-${version}-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl triton-${version}-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
  "x86_64-linux-314 $bucket/triton-${version}-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl triton-${version}-cp314-cp314-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
  "aarch64-linux-310 $bucket/triton-${version}-cp310-cp310-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl triton-${version}-cp310-cp310-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl"
  "aarch64-linux-311 $bucket/triton-${version}-cp311-cp311-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl triton-${version}-cp311-cp311-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl"
  "aarch64-linux-312 $bucket/triton-${version}-cp312-cp312-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl triton-${version}-cp312-cp312-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl"
  "aarch64-linux-313 $bucket/triton-${version}-cp313-cp313-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl triton-${version}-cp313-cp313-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl"
  "aarch64-linux-314 $bucket/triton-${version}-cp314-cp314-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl triton-${version}-cp314-cp314-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl"
)

hashfile="binary-hashes-$version.nix"
echo "  \"$version\" = {" >>$hashfile

for url_and_key in "${url_and_key_list[@]}"; do
  key=$(echo "$url_and_key" | cut -d' ' -f1)
  url=$(echo "$url_and_key" | cut -d' ' -f2)
  name=$(echo "$url_and_key" | cut -d' ' -f3)

  echo "prefetching ${url}..."
  hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 $(nix-prefetch-url "$url" --name "$name"))

  echo "    $key = {" >>$hashfile
  echo "      name = \"$name\";" >>$hashfile
  echo "      url = \"$url\";" >>$hashfile
  echo "      hash = \"$hash\";" >>$hashfile
  echo "    };" >>$hashfile

  echo
done

echo "  };" >>$hashfile
echo "done."
