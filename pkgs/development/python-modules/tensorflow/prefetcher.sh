#!/usr/bin/env bash

version="2.17.0"

bucket="https://storage.googleapis.com/tensorflow/versions/${version}"

# List of binary wheels for Tensorflow.  The most recent versions can be found
# on the following page:
# https://www.tensorflow.org/install/pip?lang=python3#package-location
url_and_key_list=(
"x86_64-linux_39 $bucket/tensorflow_cpu-${version}-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"x86_64-linux_310 $bucket/tensorflow_cpu-${version}-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"x86_64-linux_311 $bucket/tensorflow_cpu-${version}-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"x86_64-linux_312 $bucket/tensorflow_cpu-${version}-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"x86_64-linux_39_gpu $bucket/tensorflow-${version}-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"x86_64-linux_310_gpu $bucket/tensorflow-${version}-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"x86_64-linux_311_gpu $bucket/tensorflow-${version}-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"x86_64-linux_312_gpu $bucket/tensorflow-${version}-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"aarch64-linux_39 $bucket/tensorflow-${version}-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
"aarch64-linux_310 $bucket/tensorflow-${version}-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
"aarch64-linux_311 $bucket/tensorflow-${version}-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
"aarch64-linux_312 $bucket/tensorflow-${version}-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
"aarch64-darwin_39 $bucket/tensorflow-${version}-cp39-cp39-macosx_12_0_arm64.whl"
"aarch64-darwin_310 $bucket/tensorflow-${version}-cp310-cp310-macosx_12_0_arm64.whl"
"aarch64-darwin_311 $bucket/tensorflow-${version}-cp311-cp311-macosx_12_0_arm64.whl"
"aarch64-darwin_312 $bucket/tensorflow-${version}-cp312-cp312-macosx_12_0_arm64.whl"
)

hashfile=binary-hashes.nix
rm -f $hashfile
echo "{" >> $hashfile
echo "version = \"$version\";" >> $hashfile

for url_and_key in "${url_and_key_list[@]}"; do
  key=$(echo "$url_and_key" | cut -d' ' -f1)
  url=$(echo "$url_and_key" | cut -d' ' -f2)

  echo "prefetching ${url}..."
  hash=$(nix-prefetch-url $url)

  echo "$key = {" >> $hashfile
  echo "  url = \"$url\";" >> $hashfile
  echo "  sha256 = \"$hash\";" >> $hashfile
  echo "};" >> $hashfile

  echo
done

echo "}" >> $hashfile
echo "done."
