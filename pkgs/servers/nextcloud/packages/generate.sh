#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../.. -i bash -p jq gnused curl

set -e
set -u
set -o pipefail
set -x

export NEXTCLOUD_VERSIONS=$(nix-instantiate --eval -E 'import ./nc-versions.nix {}' -A e)

APPS=$(jq -r 'keys|.[]' nextcloud-apps.json | sed -z 's/\n/,/g;s/,$/\n/')

for v in ${NEXTCLOUD_VERSIONS//,/ }; do
    # Get major version and back up previous major version apps file
    v=$(sed -e 's/^"//' -e 's/"$//' <<<"$v")
    MAJOR=${v%.*.*}
    MAJOR_FILE="$MAJOR".json
    mv "$MAJOR_FILE" "$MAJOR_FILE".bak

    # Download current apps file from Nextcloud's official servers
    APPS_PER_VERSION=${v}.json
    curl "https://apps.nextcloud.com/api/v1/platform/${v}/apps.json" -o "$APPS_PER_VERSION"

    # Add a starting bracket to the apps file for this version
    echo '{' >"$MAJOR_FILE".tmp
    for a in ${APPS//,/ }; do
        echo "Fetching $a"
        # Ensure the app exists in the file
        if [ "$(jq -r ".[] | select(.id == \"${a}\")" "$APPS_PER_VERSION")" != "" ]; then
            # Get all of our variables
            VERSION=$(jq -r ".[] | select(.id == \"${a}\") | .releases[0].version" "$APPS_PER_VERSION")
            URL=$(jq -r ".[] | select(.id == \"${a}\") | .releases[0].download" "$APPS_PER_VERSION")
            HASH=$(nix store prefetch-file --json --hash-type sha256 --unpack "$URL" | jq -r .hash)
            HOMEPAGE=$(jq -r ".[] | select(.id == \"${a}\") | .website" "$APPS_PER_VERSION")
            DESCRIPTION=$(jq ".[] | select(.id == \"${a}\") | .translations.en.description" "$APPS_PER_VERSION")
            # Add all variables to the file
            cat >>"$MAJOR_FILE".tmp <<EOF
"${a}": {
"hash": "$HASH",
"url": "$URL",
"version": "$VERSION",
"description": $DESCRIPTION,
"homepage": "$HOMEPAGE"
},
EOF

        # If we can't find the app, then don't try to process it.
        else
            true
        fi
    done
    # clean up by removing last trailing comma
    sed -i '$s/,$//' "$MAJOR_FILE".tmp
    # Add final closing bracket
    echo '}' >>"$MAJOR_FILE".tmp
    # Beautify file
    jq '.' "$MAJOR_FILE".tmp >"$MAJOR_FILE"
    # Remove the temporary files
    rm "$APPS_PER_VERSION"
    rm "$MAJOR_FILE".tmp
    rm "$MAJOR_FILE".bak
done
