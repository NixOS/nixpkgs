#!/bin/sh

set -x

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin

mkdir -p "$out/bin"

for prog in "$@"; do
    cp "$(which $prog)" "$out/bin/${prog#"$prefix"}"
done
