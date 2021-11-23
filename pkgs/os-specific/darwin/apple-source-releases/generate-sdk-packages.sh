#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl
# shellcheck shell=bash

# usage:
#   generate-sdk-packages.sh macos 11.0.1

cd $(dirname "$0")

sdkName="$1-$2"
outfile="$sdkName.nix"

>$outfile echo "# Generated using:  ./$(basename "$0") $1 $2

{ applePackage' }:

{"

parse_line() {
    readarray -t -d$'\t' package <<<$2
    local pname=${package[0]} version=${package[1]}

    if [ -d $pname ]; then
        sha256=$(nix-prefetch-url "https://opensource.apple.com/tarballs/$pname/$pname-$version.tar.gz")
        >>$outfile echo "$pname = applePackage' \"$pname\" \"$version\" \"$sdkName\" \"$sha256\" {};"
    fi
}
readarray -s1 -c1 -C parse_line < <(curl -sS "https://opensource.apple.com/text/${sdkName//./}.txt")

>>$outfile echo '}'
