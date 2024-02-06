#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch curl jq

# Generates Gradle release specs from GitHub Releases.
#
# As of 2021-11, this script has very poor error handling,
# it is expected to be run by maintainers as one-off job
# only.
#
# NOTE: The earliest Gradle release that has a
# corresponding entry as GitHub Release is 6.8-rc-1.

for v in $(curl -s "https://api.github.com/repos/gradle/gradle/releases" | jq -r '.[].tag_name' | sort -n -r)
do
    # Tag names and download filenames are not the same,
    # we modify the tag name slightly to translate it
    # to the naming scheme of download filenames.
    # This translation assumes a tag naming scheme.
    # As of 2021-11 it works from 6.8-rc-1 to 7.3-rc-3.

    # Remove first letter (assumed to be "v").
    v=${v:1}

    # To lower case.
    v=${v,,}

    # Add dash after "rc".
    v=${v/-rc/-rc-}

    # Remove trailing ".0"
    v=${v%.0}

    # Remove trailing ".0" for release candidates.
    v=${v/.0-rc/-rc}

    f="gradle-${v}-spec.nix"

    if [[ -n "$1" && "$1" != "$v" ]]
    then
        echo "$v SKIP (nomatch)"
        continue
    elif [ "$1" == "" ] && [ -f "$f" ]
    then
        echo "$v SKIP (exists)"
        continue
    fi

    url="https://services.gradle.org/distributions/gradle-${v}-bin.zip"
    read -d "\n" gradle_hash gradle_path < <(nix-prefetch-url --print-path $url)

    # Prefix and suffix for "native-platform" dependency.
    gradle_native_prefix="gradle-$v/lib/native-platform-"
    gradle_native_suffix=".jar"
    tmp=$(mktemp)
    zipinfo -1 "$gradle_path" "$gradle_native_prefix*$gradle_native_suffix" > $tmp
    gradle_native=$(cat $tmp | head -n1)
    gradle_native=${gradle_native#"$gradle_native_prefix"}
    gradle_native=${gradle_native%"$gradle_native_suffix"}

    # Supported architectures
    #grep -Pho "(linux|osx)-\w+" $tmp | sort | uniq
    rm -f $tmp

    echo -e "{\\n  version = \"$v\";\\n  nativeVersion = \"$gradle_native\";\\n  sha256 = \"$gradle_hash\";\\n}" > $f

    echo "$v DONE"
done
