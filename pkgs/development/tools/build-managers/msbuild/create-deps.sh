#!/usr/bin/env nix-shell
#!nix-shell -i bash -p msbuild
set -euo pipefail

cat << EOL
{ fetchurl }: [
EOL

tmpdir="$(mktemp -d -p "$(pwd)")" # must be under source root
trap 'rm -rf $tmpdir' EXIT

(
    ulimit -n 8192 # https://github.com/NuGet/Home/issues/8571
    export HOME="$tmpdir"
    msbuild -noAutoRsp -t:restore -p:RestoreNoCache=true MSBuild.sln
    msbuild -noAutoRsp -t:restore -p:RestoreNoCache=true "$tmpdir"/.nuget/packages/microsoft.dotnet.arcade.sdk/*/tools/Tools.proj
) | \
    sed -nr 's/^ *OK *(.*\.nupkg).*$/\1/p' | \
    sort -u | \
    while read url; do
        sha256=$(nix-prefetch-url "$url" 2>/dev/null)
        cat << EOL
  (fetchurl {
    url = "$url";
    sha256 = "$sha256";
  })
EOL
    done

cat << EOL
]
EOL
