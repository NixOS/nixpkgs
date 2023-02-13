#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash coreutils curl jq

urls=()
urls+=(https://out7.hex-rays.com/files/idafree82_windows.exe)
urls+=(https://out7.hex-rays.com/files/idafree82_linux.run)
urls+=(https://out7.hex-rays.com/files/idafree82_mac.app.zip)
urls+=(https://out7.hex-rays.com/files/arm_idafree82_mac.app.zip)

hashPrefix=sha256:

cd "$(dirname "$0")"

source_json_file=src.json

old_source_json='{}'
if [ -e $source_json_file ]; then
    # parse old source info
    old_source_json="$(< $source_json_file)"
fi

new_source_json="$old_source_json"

# parse hashes
if true; then
html=$(curl -s https://hex-rays.com/ida-free/)
else
html=$(cat <<'EOF'
test
https://hex-rays.com/ida-free/
b77a56913d669240b53f1cfd2deec20c3f4b00cbf286bedae46172e11f06431a  arm_idafree82_mac.app.zip
a5cc9bf0cdfd14956c594010897cb5ee73ad55484f90fb04db862a84af6b2b9f  idafree82_linux.run
60cd970c6aa01e14f488ef28c6017eca28bf447509f40176a1a982bb8e90f12a  idafree82_mac.app.zip
2289a03c9f2f2c2fa3de86453139302108a32abf3b98d27267b2c9bfa48056cf  idafree82_windows.exe
EOF
)
fi

hash_regex='[0-9a-f]{64}' # sha256base16

hashes_raw=$(echo "$html" | grep -E "^$hash_regex  [a-z0-9_.]*idafree[a-z0-9_.]+\.(run|zip|exe)$")

echo "hashes_raw:"
echo "$hashes_raw"

declare -A hashes
while read line; do
    sha256base16=$(echo "$line" | sed -E "s/^($hash_regex)  (.+)$/\1/")
    file=$(echo "$line" | sed -E "s/^($hash_regex)  (.+)$/\2/")
    hashes[$file]=$sha256base16
done <<< "$hashes_raw"

for url in "${urls[@]}"; do
    file=$(basename "$url")

    # parse platform from $file
    # arm_idafree82_mac.app.zip
    if echo "$file" | grep -qE '^arm_idafree[0-9]+_mac.app.zip$'; then
        platform=armv7a-darwin
    # idafree82_mac.app.zip
    elif echo "$file" | grep -qE '^idafree[0-9]+_mac.app.zip$'; then
        platform=x86_64-darwin
    # idafree82_linux.run
    elif echo "$file" | grep -qE '^idafree[0-9]+_linux.run$'; then
        platform=x86_64-linux
    # idafree82_windows.exe
    elif echo "$file" | grep -qE '^idafree[0-9]+_windows.exe$'; then
        platform=x86_64-windows
    else
        platform=fixme-unknown-platform-of-file-$file
    fi

    sha256base16=${hashes[$file]}
    hash="$hashPrefix$sha256base16"
    hashOld="$(echo "$old_source_json" | jq -r '.[$platform].hash' --arg platform "$platform")"
    #sha256base16Old=${hashOld/$hashPrefix/}

    if [[ "$hash" == "$hashOld" ]]
    then
        echo "source is up-to-date (same hash)"
        continue
    fi

    echo "hash changed:"
    echo "-hash: $hashOld"
    echo "+hash: $hash"

    contentLengthOld="$(echo "$old_source_json" | jq -r '.[$platform].contentLength' --arg platform "$platform")"
    lastModifiedOld="$(echo "$old_source_json" | jq -r '.[$platform].lastModified' --arg platform "$platform")"

    echo fetching headers
    headers=$(curl -s -I $url | tr -d $'\r')
    contentLength=$(echo "$headers" | grep "^Content-Length:" | tail -n1)
    contentLength=''${contentLength:16}
    lastModified=$(echo "$headers" | grep "^Last-Modified:" | tail -n1)
    lastModified=''${lastModified:15}

    versionDate=$(date --utc -d"$lastModified" +%y%m%d)
    lastModified=$(date --utc -d"$lastModified" +"%FT%T%z") # "iso strict" format

    # parse version from $file
    versionNumber=$(echo "$file" | sed -E 's/^.*idafree([0-9])([0-9])_.*$/\1.\2/')

    version="$versionNumber.$versionDate"

    echo "$lastModified $url"

    # hash changed
    if false; then
    if [[ "$contentLengthOld" == "$contentLength" && "$lastModifiedOld" == "$lastModified" ]]
    then
        echo "source is up-to-date"
        continue
    fi
    fi

    #echo "original url changed:"
    if [[ "$contentLengthOld" != "$contentLength" ]]; then
        echo "-Content-Length: $contentLengthOld"
        echo "+Content-Length: $contentLength"
    fi
    if [[ "$lastModifiedOld" != "$lastModified" ]]; then
        echo "-Last-Modified: $lastModifiedOld"
        echo "+Last-Modified: $lastModified"
    fi

    # update source info
    new_source_json="$(
        echo "$new_source_json" | jq --sort-keys --slurp '
            [.[0], {
                ($platform): {
                    "url": $url,
                    "hash": $hash,
                    "version": $version,
                    "contentLength": $contentLength,
                    "lastModified": $lastModified
                }
            }] | add
        ' \
        --argjson contentLength "$contentLength" \
        --arg lastModified "$lastModified" \
        --arg hash "$hash" \
        --arg version "$version" \
        --arg platform "$platform" \
        --arg url "$url" \
    )"

done

echo updating $source_json_file
echo "$new_source_json" >$source_json_file
