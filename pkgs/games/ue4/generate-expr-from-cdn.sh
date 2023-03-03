#!/bin/sh

go() {
    file="$1"

    IFS=$'\n'
    for pack in $(perl -n -e '/(<Pack .*\/>)/ && print "$1\n"' $file); do
        remotepath=$(echo "$pack" | perl -n -e '/RemotePath="([^"]*)"/ && print $1')
        hash=$(echo "$pack" | perl -n -e '/Hash="([^"]*)"/ && print $1')
        url="http://cdn.unrealengine.com/dependencies/$remotepath/$hash"

        until sha256=$(nix-prefetch-url $url --type sha256); do
            true
        done

        cat <<EOF
  "$hash" = fetchurl {
    url = $url;
    sha256 = "$sha256";
  };
EOF
    done
}


cat <<EOF
{ fetchurl }:

{
EOF

go Engine/Build/Commit.gitdeps.xml
go Engine/Build/Promoted.gitdeps.xml

cat <<EOF
}
EOF
