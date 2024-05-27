#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-scripts

set -eou pipefail

version=$1

linux_cuda_version="cu121"
linux_bucket="https://download.pytorch.org/whl/${linux_cuda_version}"
darwin_bucket="https://download.pytorch.org/whl/cpu"

url_and_key_list=(
  "x86_64-linux-38 $linux_bucket/torchvision-${version}%2B${linux_cuda_version}-cp38-cp38-linux_x86_64.whl torchvision-${version}-cp38-cp38-linux_x86_64.whl"
  "x86_64-linux-39 $linux_bucket/torchvision-${version}%2B${linux_cuda_version}-cp39-cp39-linux_x86_64.whl torchvision-${version}-cp39-cp39-linux_x86_64.whl"
  "x86_64-linux-310 $linux_bucket/torchvision-${version}%2B${linux_cuda_version}-cp310-cp310-linux_x86_64.whl torchvision-${version}-cp310-cp310-linux_x86_64.whl"
  "x86_64-linux-311 $linux_bucket/torchvision-${version}%2B${linux_cuda_version}-cp311-cp311-linux_x86_64.whl torchvision-${version}-cp311-cp311-linux_x86_64.whl"
  "x86_64-linux-312 $linux_bucket/torchvision-${version}%2B${linux_cuda_version}-cp312-cp312-linux_x86_64.whl torchvision-${version}-cp312-cp312-linux_x86_64.whl"
  "aarch64-darwin-38 $darwin_bucket/torchvision-${version}-cp38-cp38-macosx_11_0_arm64.whl torchvision-${version}-cp38-cp38-macosx_11_0_arm64.whl"
  "aarch64-darwin-39 $darwin_bucket/torchvision-${version}-cp39-cp39-macosx_11_0_arm64.whl torchvision-${version}-cp39-cp39-macosx_11_0_arm64.whl"
  "aarch64-darwin-310 $darwin_bucket/torchvision-${version}-cp310-cp310-macosx_11_0_arm64.whl torchvision-${version}-cp310-cp310-macosx_11_0_arm64.whl"
  "aarch64-darwin-311 $darwin_bucket/torchvision-${version}-cp311-cp311-macosx_11_0_arm64.whl torchvision-${version}-cp311-cp311-macosx_11_0_arm64.whl"
  "aarch64-darwin-312 $darwin_bucket/torchvision-${version}-cp312-cp312-macosx_11_0_arm64.whl torchvision-${version}-cp312-cp312-macosx_11_0_arm64.whl"
  "aarch64-linux-38 $darwin_bucket/torchvision-${version}-cp38-cp38-linux_aarch64.whl torchvision-${version}-cp38-cp38-linux_aarch64.whl"
  "aarch64-linux-39 $darwin_bucket/torchvision-${version}-cp39-cp39-linux_aarch64.whl torchvision-${version}-cp39-cp39-linux_aarch64.whl"
  "aarch64-linux-310 $darwin_bucket/torchvision-${version}-cp310-cp310-linux_aarch64.whl torchvision-${version}-cp310-cp310-linux_aarch64.whl"
  "aarch64-linux-311 $darwin_bucket/torchvision-${version}-cp311-cp311-linux_aarch64.whl torchvision-${version}-cp311-cp311-linux_aarch64.whl"
  "aarch64-linux-312 $darwin_bucket/torchvision-${version}-cp312-cp312-linux_aarch64.whl torchvision-${version}-cp312-cp312-linux_aarch64.whl"
)

hashfile="binary-hashes-$version.nix"
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
