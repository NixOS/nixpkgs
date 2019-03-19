#!/usr/bin/env nix-shell
#!nix-shell -p httpie
#!nix-shell -p jq
#!nix-shell -i bash

set -eu -o pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

get_download_info() {
    echo '{ "sys": "'"$1-$2"'", "response": '
    http --body \
         https://update.equinox.io/check \
         'Accept:application/json; q=1; version=1; charset=utf-8' \
         'Content-Type:application/json; charset=utf-8' \
         app_id=app_goVRodbMVm \
         channel=stable \
         os=$1 \
         goarm= \
         arch=$2

#         target_version=2.2.8 \

    echo "}"
}

(
    echo "["
    get_download_info linux 386
    echo ","
    get_download_info linux amd64
    echo ","
    get_download_info linux arm
    echo ","
    get_download_info linux arm64
    # echo ","
    # get_download_info darwin 386
    echo ","
    get_download_info darwin amd64
    echo "]"
) | jq 'map ({ (.sys): { "sys": .sys, "url": .response.download_url, "sha256": .response.checksum, "version": .response.release.version } }) | add' >versions.json
