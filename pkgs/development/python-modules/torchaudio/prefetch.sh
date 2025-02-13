#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-scripts

set -eou pipefail

version=$1

linux_cuda_version="cu124"
linux_cuda_bucket="https://download.pytorch.org/whl/${linux_cuda_version}"
linux_cpu_bucket="https://download.pytorch.org/whl/cpu"
darwin_bucket="https://download.pytorch.org/whl/cpu"

url_and_key_list=(
    "x86_64-linux-39 $linux_cuda_bucket/torchaudio-${version}%2B${linux_cuda_version}-cp39-cp39-linux_x86_64.whl torchaudio-${version}-cp39-cp39-linux_x86_64.whl"
    "x86_64-linux-310 $linux_cuda_bucket/torchaudio-${version}%2B${linux_cuda_version}-cp310-cp310-linux_x86_64.whl torchaudio-${version}-cp310-cp310-linux_x86_64.whl"
    "x86_64-linux-311 $linux_cuda_bucket/torchaudio-${version}%2B${linux_cuda_version}-cp311-cp311-linux_x86_64.whl torchaudio-${version}-cp311-cp311-linux_x86_64.whl"
    "x86_64-linux-312 $linux_cuda_bucket/torchaudio-${version}%2B${linux_cuda_version}-cp312-cp312-linux_x86_64.whl torchaudio-${version}-cp312-cp312-linux_x86_64.whl"
    "aarch64-darwin-39 $darwin_bucket/torchaudio-${version}-cp39-cp39-macosx_11_0_arm64.whl torchaudio-${version}-cp39-cp39-macosx_11_0_arm64.whl"
    "aarch64-darwin-310 $darwin_bucket/torchaudio-${version}-cp310-cp310-macosx_11_0_arm64.whl torchaudio-${version}-cp310-cp310-macosx_11_0_arm64.whl"
    "aarch64-darwin-311 $darwin_bucket/torchaudio-${version}-cp311-cp311-macosx_11_0_arm64.whl torchaudio-${version}-cp311-cp311-macosx_11_0_arm64.whl"
    "aarch64-darwin-312 $darwin_bucket/torchaudio-${version}-cp312-cp312-macosx_11_0_arm64.whl torchaudio-${version}-cp312-cp312-macosx_11_0_arm64.whl"
    "aarch64-linux-39 $linux_cpu_bucket/torchaudio-${version}-cp39-cp39-linux_aarch64.whl torchaudio-${version}-cp39-cp39-manylinux2014_aarch64.whl"
    "aarch64-linux-310 $linux_cpu_bucket/torchaudio-${version}-cp310-cp310-linux_aarch64.whl torchaudio-${version}-cp310-cp310-manylinux2014_aarch64.whl"
    "aarch64-linux-311 $linux_cpu_bucket/torchaudio-${version}-cp311-cp311-linux_aarch64.whl torchaudio-${version}-cp311-cp311-manylinux2014_aarch64.whl"
    "aarch64-linux-312 $linux_cpu_bucket/torchaudio-${version}-cp312-cp312-linux_aarch64.whl torchaudio-${version}-cp312-cp312-manylinux2014_aarch64.whl"
)

hashfile=binary-hashes-"$version".nix
echo "  \"$version\" = {" >>$hashfile

for url_and_key in "${url_and_key_list[@]}"; do
    key=$(echo "$url_and_key" | cut -d' ' -f1)
    url=$(echo "$url_and_key" | cut -d' ' -f2)
    name=$(echo "$url_and_key" | cut -d' ' -f3)

    echo "prefetching ${url}..."
    hash=$(nix hash convert --hash-algo sha256 $(nix-prefetch-url "$url" --name "$name"))

    echo "    $key = {" >>$hashfile
    echo "      name = \"$name\";" >>$hashfile
    echo "      url = \"$url\";" >>$hashfile
    echo "      hash = \"$hash\";" >>$hashfile
    echo "    };" >>$hashfile

    echo
done

echo "  };" >>$hashfile
echo "done."
