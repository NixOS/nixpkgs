#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-scripts

set -eou pipefail

version=$1

linux_cuda_version="cu132"
linux_cuda_bucket="https://download.pytorch.org/whl/${linux_cuda_version}"
linux_cpu_bucket="https://download.pytorch.org/whl/cpu"
darwin_bucket="https://download.pytorch.org/whl/cpu"

url_and_key_list=(
  "x86_64-linux $linux_cuda_bucket/torchaudio-${version}%2B${linux_cuda_version}-py3-none-manylinux_2_28_x86_64.whl torchaudio-${version}-py3-none-linux_x86_64.whl"
  "aarch64-darwin $darwin_bucket/torchaudio-${version}-py3-none-macosx_14_0_arm64.whl torchaudio-${version}-py3-none-macosx_14_0_arm64.whl"
  "aarch64-linux $linux_cpu_bucket/torchaudio-${version}%2Bcpu-py3-none-manylinux_2_28_aarch64.whl torchaudio-${version}-py3-none-manylinux_2_28_aarch64.whl"
)

hashfile=binary-hashes-"$version".nix
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
