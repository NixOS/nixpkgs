if [[ -z "${UPDATE_NIX_ATTR_PATH:-}" ]]; then
    echo "Missing UPDATE_NIX_ATTR_PATH - make sure you use mainters/scripts/update.nix to run this script!" 1>&2
    exit 1
fi

attrPath="$UPDATE_NIX_ATTR_PATH"

nixFilePath="$(pwd)/pkgs/games/openra/engines/$build/default.nix"
if [[ ! -f "$nixFilePath" ]]; then
    echo "$nixFilePath does not exist!" 1>&2
    exit 1
fi

depsFilePath="$(pwd)/pkgs/games/openra/engines/$build/deps.json"
if [[ ! -f "$depsFilePath" ]]; then
    echo "$depsFilePath does not exist!" 1>&2
    exit 1
fi

# if on bleed, update to the latest commit from the bleed branch
# otherwise, check Github releases for releases with a matching prefix
declare newVersion
declare newHash
if [[ "$build" == "bleed" ]]; then
    prefetchResult=$(nix-prefetch-github OpenRA OpenRA --json --rev "$build")

    newRev=$(echo "$prefetchResult" | jq -e -r '.rev')
    if [[ "$currentRev" == "$newRev" ]]; then
        echo "Already up to date!" 1>&2
        echo "[]"
        exit 0
    fi

    # update rev
    sed -i -E 's#(rev = ").*(";)#\1'"$newRev"'\2#' "$nixFilePath"

    # get new version based on commit date from github
    newVersion=$(curl -s "https://api.github.com/repos/OpenRA/OpenRA/commits/$newRev" |\
        jq -r '.commit.committer.date' |\
        xargs -I{} date -d {} +%Y%m%d)

    newHash=$(echo "$prefetchResult" | jq -e -r '.hash')
else
    newVersion=$(curl -s "https://api.github.com/repos/OpenRA/OpenRA/releases" |\
    jq -r --arg prefix "$build" \
      'first(.[] | select(.tag_name | startswith($prefix)) | .tag_name) | split("-")[1]')

    if [[ "$currentVersion" == "$newVersion" ]]; then
        echo "Already up to date!" 1>&2
        echo "[]"
        exit 0
    fi

    newHash=$(nix-prefetch-github OpenRA OpenRA --json --rev "$build-$newVersion" | jq -r '.hash')
fi

# update version
sed -i -E 's#(version = ").*(";)#\1'"$newVersion"'\2#' "$nixFilePath"

# update hash
sed -i -E 's#(hash = ").*(";)#\1'"$newHash"'\2#' "$nixFilePath"

# update deps.json by running the fetch-deps script
# shellcheck disable=SC2091
$(nix-build -A "$attrPath".fetch-deps --no-out-link) 1>&2

# echo commit info, according to what maintainers/scripts/update.nix needs
cat <<-EOF
[{
    "attrPath": "$attrPath",
    "oldVersion": "$currentVersion",
    "newVersion": "$newVersion",
    "files": ["$nixFilePath", "$depsFilePath"]
}]
EOF
