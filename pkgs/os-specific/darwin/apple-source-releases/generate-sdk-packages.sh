#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

# usage:
#   generate-sdk-packages.sh macos 11.0.1

cd $(dirname "$0")

sdkName="$1-$2"
outfile="$sdkName.nix"

>$outfile echo "# Generated using:  ./$(basename "$0") $1 $2

{ applePackage' }:

{"

parse_line() {
    readarray -t -d$'-' package < <(printf "%s" $2)
    local pname=${package[0]} version=${package[1]}

    if [ -d $pname ]; then
        sha256=$(nix-prefetch-url "https://github.com/apple-oss-distributions/$pname/archive/refs/tags/$pname-$version.tar.gz")
        >>$outfile echo "$pname = applePackage' \"$pname\" \"$version\" \"$sdkName\" \"$sha256\" {};"
    fi
}
readarray -s1 -c1 -C parse_line < <(curl -sSL "https://github.com/apple-oss-distributions/distribution-${1//-/_}/raw/${sdkName//./}/release.json" | jq -r ".projects[].tag")

>>$outfile echo '}'
