#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq -p xmlstarlet -p curl
# shellcheck shell=bash
set -euo pipefail

cat << EOL
{ fetchurl }: [
EOL

mapfile -t repos < <(
    xmlstarlet sel -t -v 'configuration/packageSources/add/@value' -n NuGet.config |
        while IFS= read index
        do
            curl --compressed -fsL "$index" | \
                jq -r '.resources[] | select(."@type" == "PackageBaseAddress/3.0.0")."@id"'
        done
    )

find .packages fake-home/.nuget/packages -name \*.nupkg -printf '%P\n' | sort -u |
    while IFS= read file
    do
        packagedir=$(dirname $file)
        version=$(basename $packagedir)
        package=$(dirname $packagedir)

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

cat << EOL
]
EOL
