#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-scripts

set -eou pipefail

version=$1

linux_cuda_version="cu124"
linux_cuda_bucket="https://download.pytorch.org/whl/${linux_cuda_version}"
linux_cpu_bucket="https://download.pytorch.org/whl/cpu"
darwin_bucket="https://download.pytorch.org/whl/cpu"

url_and_key_list=(
  "x86_64-linux-39 $linux_cuda_bucket/torch-${version}%2B${linux_cuda_version}-cp39-cp39-linux_x86_64.whl torch-${version}-cp39-cp39-linux_x86_64.whl"
  "x86_64-linux-310 $linux_cuda_bucket/torch-${version}%2B${linux_cuda_version}-cp310-cp310-linux_x86_64.whl torch-${version}-cp310-cp310-linux_x86_64.whl"
  "x86_64-linux-311 $linux_cuda_bucket/torch-${version}%2B${linux_cuda_version}-cp311-cp311-linux_x86_64.whl torch-${version}-cp311-cp311-linux_x86_64.whl"
  "x86_64-linux-312 $linux_cuda_bucket/torch-${version}%2B${linux_cuda_version}-cp312-cp312-linux_x86_64.whl torch-${version}-cp312-cp312-linux_x86_64.whl"
  "aarch64-darwin-39 $darwin_bucket/torch-${version}-cp39-none-macosx_11_0_arm64.whl torch-${version}-cp39-none-macosx_11_0_arm64.whl"
  "aarch64-darwin-310 $darwin_bucket/torch-${version}-cp310-none-macosx_11_0_arm64.whl torch-${version}-cp310-none-macosx_11_0_arm64.whl"
  "aarch64-darwin-311 $darwin_bucket/torch-${version}-cp311-none-macosx_11_0_arm64.whl torch-${version}-cp311-none-macosx_11_0_arm64.whl"
  "aarch64-darwin-312 $darwin_bucket/torch-${version}-cp312-none-macosx_11_0_arm64.whl torch-${version}-cp312-none-macosx_11_0_arm64.whl"
  "aarch64-linux-39 $linux_cpu_bucket/torch-${version}-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl torch-${version}-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
  "aarch64-linux-310 $linux_cpu_bucket/torch-${version}-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl torch-${version}-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
  "aarch64-linux-311 $linux_cpu_bucket/torch-${version}-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl torch-${version}-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
  "aarch64-linux-312 $linux_cpu_bucket/torch-${version}-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl torch-${version}-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
)

hashfile="binary-hashes-$version.nix"
echo "  \"$version\" = {" >> $hashfile

for url_and_key in "${url_and_key_list[@]}"; do
  key=$(echo "$url_and_key" | cut -d' ' -f1)
  url=$(echo "$url_and_key" | cut -d' ' -f2)
  name=$(echo "$url_and_key" | cut -d' ' -f3)

  echo "prefetching ${url}..."
  hash=$(nix hash convert --hash-algo sha256 `nix-prefetch-url "$url" --name "$name"`)

  echo "    $key = {" >> $hashfile
  echo "      name = \"$name\";" >> $hashfile
  echo "      url = \"$url\";" >> $hashfile
  echo "      hash = \"$hash\";" >> $hashfile
  echo "    };" >> $hashfile

  echo
done

echo "  };" >> $hashfile
echo "done."
