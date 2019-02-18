#!/bin/sh

echo "{"
grep -v -F '.bin-' | while read path; do
    hash=`nix-hash --type sha1 --base32 "$path"`
    echo -n "$path" | sed -E 's/[^-]*-texlive-(.*)/"\1"/'
    echo "=\"$hash\";"
done
echo "}"

