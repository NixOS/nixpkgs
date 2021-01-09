#!/usr/bin/env bash

version=2.1.0

# List of binary wheels for Tensorflow.  The most recent versions can be found
# on the following page:
# https://www.tensorflow.org/install/pip?lang=python3#package-location
url_and_key_list=(
  "linux_py_27_gpu https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-${version}-cp27-cp27mu-manylinux2010_x86_64.whl"
  "linux_py_27_cpu https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow_cpu-${version}-cp27-cp27mu-manylinux2010_x86_64.whl"
  "linux_py_35_gpu https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-${version}-cp35-cp35m-manylinux2010_x86_64.whl"
  "linux_py_35_cpu https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow_cpu-${version}-cp35-cp35m-manylinux2010_x86_64.whl"
  "linux_py_36_gpu https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-${version}-cp36-cp36m-manylinux2010_x86_64.whl"
  "linux_py_36_cpu https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow_cpu-${version}-cp36-cp36m-manylinux2010_x86_64.whl"
  "linux_py_37_gpu https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-${version}-cp37-cp37m-manylinux2010_x86_64.whl"
  "linux_py_37_cpu https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow_cpu-${version}-cp37-cp37m-manylinux2010_x86_64.whl"
  "mac_py_27_cpu https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-${version}-cp27-cp27m-macosx_10_9_x86_64.whl"
  "mac_py_35_cpu https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-${version}-cp35-cp35m-macosx_10_6_intel.whl"
  "mac_py_36_cpu https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-${version}-cp36-cp36m-macosx_10_9_x86_64.whl"
  "mac_py_37_cpu https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-${version}-cp37-cp37m-macosx_10_9_x86_64.whl"
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
