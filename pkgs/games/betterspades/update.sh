#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq nix-prefetch-github

set -euo pipefail

cd $(dirname "${BASH_SOURCE[0]}")

alias curl='curl -sL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"}'

get_last_commit(){
    curl "https://api.github.com/repos/$1/$2/commits/$3" | jq -r .sha
}

hash_repo(){
    nix-prefetch-github "$1" "$2" --rev "$3" | jq -r .sha256
}

hash_file(){
    nix-prefetch-url --quiet --type sha256 "$1"
}

BetterSpades_tag=$(curl -sL https://api.github.com/repos/xtreme8000/BetterSpades/tags | jq -r .[0].name)
BetterSpades_ver=$(echo "$BetterSpades_tag" | sed -e 's/^v//')
BetterSpades_sha256=$(hash_repo xtreme8000 BetterSpades "$BetterSpades_tag")

libvxl_commit=$(get_last_commit xtreme8000 libvxl master)
libvxl_sha256=$(hash_repo xtreme8000 libvxl "$libvxl_commit")

ini_commit=$(get_last_commit benhoyt inih master)
ini_sha256=$(hash_repo benhoyt inih "$ini_commit")

lodepng_commit=$(get_last_commit lvandeve lodepng master)
lodepng_sha256=$(hash_repo lvandeve lodepng "$lodepng_commit")

stb_truetype_commit=$(get_last_commit nothings stb master)
stb_truetype_sha256=$(hash_file "https://raw.githubusercontent.com/nothings/stb/$stb_truetype_commit/stb_truetype.h")

parson_commit=$(get_last_commit kgabis parson master)
parson_sha256=$(hash_repo kgabis parson "$parson_commit")

http_commit=$(get_last_commit mattiasgustavsson libs main)
http_sha256=$(hash_file "https://raw.githubusercontent.com/mattiasgustavsson/libs/$http_commit/http.h")

log_commit=$(get_last_commit xtreme8000 log.c master)
log_sha256=$(hash_repo xtreme8000 log.c "$log_commit")

hashtable_commit=$(get_last_commit goldsborough hashtable master)
hashtable_sha256=$(hash_repo goldsborough hashtable "$hashtable_commit")

libdeflate_commit=$(get_last_commit ebiggers libdeflate master)
libdeflate_sha256=$(hash_file "https://raw.githubusercontent.com/ebiggers/libdeflate/$libdeflate_commit/libdeflate.h")

microui_commit=$(get_last_commit rxi microui master)
microui_sha256=$(hash_repo rxi microui "$microui_commit")

setKV () {
    sed -i -e "s|$1 = \".*\"|$1 = \"${2:-}\"|" ./default.nix
}

setKV betterspades-v.version "${BetterSpades_ver}"
setKV betterspades-v.sha256 "${BetterSpades_sha256}"

setKV ini.commit "$ini_commit"
setKV ini.sha256 "$ini_sha256"

setKV lodepng.commit "$lodepng_commit"
setKV lodepng.sha256 "$lodepng_sha256"

setKV parson.commit "$parson_commit"
setKV parson.sha256 "$parson_sha256"

setKV log.commit "$log_commit"
setKV log.sha256 "$log_sha256"

setKV hashtable.commit "$hashtable_commit"
setKV hashtable.sha256 "$hashtable_sha256"

setKV microui.commit "$microui_commit"
setKV microui.sha256 "$microui_sha256"

setKV libvxl.rev "$libvxl_commit"
setKV libvxl.sha256 "$libvxl_sha256"

setKV stb_truetype.commit "$stb_truetype_commit"
setKV stb_truetype.sha256 "$stb_truetype_sha256"

setKV http.commit "$http_commit"
setKV http.sha256 "$http_sha256"

setKV libdeflate.commit "$libdeflate_commit"
setKV libdeflate.sha256 "$libdeflate_sha256"
