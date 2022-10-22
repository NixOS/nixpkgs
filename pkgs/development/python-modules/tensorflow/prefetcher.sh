#!/usr/bin/env bash

version="2.9.1"

bucket="https://storage.googleapis.com/tensorflow"

# List of binary wheels for Tensorflow.  The most recent versions can be found
# on the following page:
# https://www.tensorflow.org/install/pip?lang=python3#package-location
url_and_key_list=(
"linux_py_37_cpu $bucket/linux/cpu/tensorflow_cpu-${version}-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"linux_py_38_cpu $bucket/linux/cpu/tensorflow_cpu-${version}-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"linux_py_39_cpu $bucket/linux/cpu/tensorflow_cpu-${version}-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"linux_py_310_cpu $bucket/linux/cpu/tensorflow_cpu-${version}-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"linux_py_37_gpu $bucket/linux/gpu/tensorflow_gpu-${version}-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"linux_py_38_gpu $bucket/linux/gpu/tensorflow_gpu-${version}-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"linux_py_39_gpu $bucket/linux/gpu/tensorflow_gpu-${version}-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"linux_py_310_gpu $bucket/linux/gpu/tensorflow_gpu-${version}-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
"mac_py_37_cpu $bucket/mac/cpu/tensorflow-${version}-cp37-cp37m-macosx_10_14_x86_64.whl"
"mac_py_38_cpu $bucket/mac/cpu/tensorflow-${version}-cp38-cp38-macosx_10_14_x86_64.whl"
"mac_py_39_cpu $bucket/mac/cpu/tensorflow-${version}-cp39-cp39-macosx_10_14_x86_64.whl"
"mac_py_310_cpu $bucket/mac/cpu/tensorflow-${version}-cp310-cp310-macosx_10_14_x86_64.whl"
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
