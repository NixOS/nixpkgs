#!/usr/bin/env bash

version=$(curl -s https://pypi.org/project/tensorflow/ | grep -A1 'release__version' | grep -v 'release__version'  | head -n 1 | sed "s| ||g")

# List of binary wheels for Tensorflow.  The most recent versions can be found
# on the following page:
# https://www.tensorflow.org/install/pip?lang=python3#package-location

hashfile=binary-hashes.nix
rm -f $hashfile
echo "{" >> $hashfile
echo "version = \"$version\";" >> $hashfile

# this big ol mess really just does a regex match and then takes some of the groups
curl -s https://www.tensorflow.org/install/pip?lang=python3#package-location | grep storage | grep -o "https.*whl" | sed -r "s|(.+tensorflow\/([a-z]+)\/([a-z]+)\/.+cp([0-9][0-9]).+)|\2_py_\4_\3 \1|g" | grep -v "windows" | grep -v "raspberrypi" |
(while read url_and_key; do
  key=$(echo "$url_and_key" | cut -d' ' -f1)
  url=$(echo "$url_and_key" | cut -d' ' -f2)

  echo "prefetching ${url}..."
  hash=$(nix-prefetch-url $url)

  echo "$key = {" >> $hashfile
  echo "  url = \"$url\";" >> $hashfile
  echo "  sha256 = \"$hash\";" >> $hashfile
  echo "};" >> $hashfile

  echo
done)

echo "}" >> $hashfile
echo "done."
