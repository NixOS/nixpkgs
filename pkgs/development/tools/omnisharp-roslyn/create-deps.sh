#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../.. -i bash -p msbuild dotnet-sdk_3 jq xmlstarlet curl
# shellcheck shell=bash
set -euo pipefail

cat << EOL
{ fetchurl }: [
EOL

tmpdir="$(mktemp -d -p "$(pwd)")" # must be under source root
trap 'rm -rf "$tmpdir"' EXIT

mapfile -t repos < <(
    xmlstarlet sel -t -v 'configuration/packageSources/add/@value' -n NuGet.Config |
        while IFS= read index
        do
            curl --compressed -fsL "$index" | \
                jq -r '.resources[] | select(."@type" == "PackageBaseAddress/3.0.0")."@id"'
        done
    )

msbuild -t:restore -p:Configuration=Release -p:RestorePackagesPath="$tmpdir" \
        -p:RestoreNoCache=true -p:RestoreForce=true \
        src/OmniSharp.Stdio.Driver/OmniSharp.Stdio.Driver.csproj >&2

cd "$tmpdir"
for package in *
do
    cd "$package"
    for version in *
    do
        found=false
        for repo in "${repos[@]}"
        do
            url="$repo$package/$version/$package.$version.nupkg"
            if curl -fsL "$url" -o /dev/null
            then
                found=true
                break
            fi
        done

        if ! $found
        then
            echo "couldn't find $package $version" >&2
            exit 1
        fi

        sha256=$(nix-prefetch-url "$url" 2>/dev/null)
        cat << EOL
  {
    name = "$package";
    version = "$version";
    src = fetchurl {
      url = "$url";
      sha256 = "$sha256";
    };
  }
EOL
    done
    cd ..
done
cd ..

cat << EOL
]
EOL
