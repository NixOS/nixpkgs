#!/usr/bin/env bash

# for mod in $(nix eval --raw '(
#   with import <nixpkgs> { };
#   with lib;
#   let mods = attrNames (removeAttrs openraPackages.mods [ "recurseForDerivations" ]);
#   in concatStringsSep " " mods
# )'); do
#   ./mod-update.sh "$mod"
# done

# Uses:
# https://github.com/msteen/nix-prefetch
# https://github.com/msteen/nix-update-fetch

mod=$1
commit_count=$2
token=
nixpkgs='<nixpkgs>'

die() {
  ret=$?
  echo "$*" >&2
  exit $ret
}

curl() {
  command curl --silent --show-error "$@"
}

get_sha1() {
  local owner=$1 repo=$2 ref=$3
  # https://developer.github.com/v3/#authentication
  curl -H "Authorization: token $token" -H 'Accept: application/vnd.github.VERSION.sha' "https://api.github.com/repos/$owner/$repo/commits/$ref"
}

[[ -n $token ]] || die "Please edit this script to include a GitHub API access token, which is required for API v4:
https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/"

# Get current mod_owner and mod_repo.
vars=$(nix-prefetch --file "$nixpkgs" "openraPackages.mods.$mod" --index 0 --quiet --output json --skip-hash > >(
  jq --raw-output 'with_entries(select(.value | contains("\n") | not)) | to_entries | .[] | .key + "=" + .value')) || exit

while IFS='=' read -r key val; do
  declare "mod_${key}=${val}"
done <<< "$vars"

if [[ -n $commit_count ]]; then
  query_on_commit='{
  history(first: 10) {
    nodes {
      abbreviatedOid
      oid
    }
    totalCount
  }
}'
else
  query_on_commit='{
  history(first: 0) {
    totalCount
  }
  abbreviatedOid
  oid
}'
fi

query='query {
  repository(owner: \"'"$mod_owner"'\", name: \"'"$mod_repo"'\") {
    defaultBranchRef {
      target {
        ... on Commit '"$query_on_commit"'
      }
    }
    licenseInfo {
      key
    }
  }
}'

# Newlines are not allowed in a query.
# https://developer.github.com/v4/guides/forming-calls/#communicating-with-graphql
query=$(echo $query)

# https://developer.github.com/v4/guides/using-the-explorer/#configuring-graphiql
json=$(curl -H "Authorization: bearer $token" -X POST -d '{ "query": "'"$query"'" }' https://api.github.com/graphql) || exit

if [[ -n $commit_count ]]; then
  json=$(jq "$commit_count"' as $commit_count
    | .data.repository.defaultBranchRef.target
    |= (.history |= (. | del(.nodes) | .totalCount = $commit_count))
    + (.history | .nodes[.totalCount - $commit_count])' <<< "$json") || exit
fi

vars=$(jq --raw-output '.data.repository | {
  license_key: .licenseInfo.key,
} + (.defaultBranchRef.target | {
  version: ((.history.totalCount | tostring) + ".git." + .abbreviatedOid),
  rev: .oid,
}) | to_entries | .[] | .key + "=" + (.value | tostring)' <<< "$json") || exit

while IFS='=' read -r key val; do
  declare "mod_${key}=${val}"
done <<< "$vars"

mod_config=$(curl "https://raw.githubusercontent.com/$mod_owner/$mod_repo/$mod_rev/mod.config") || exit

while IFS='=' read -r key val; do
  declare "${key,,}=$(jq --raw-output . <<< "$val")"
done < <(grep '^\(MOD_ID\|ENGINE_VERSION\|AUTOMATIC_ENGINE_MANAGEMENT\|AUTOMATIC_ENGINE_SOURCE\)=' <<< "$mod_config")

for var in mod_id engine_version automatic_engine_management automatic_engine_source; do
  echo "$var=${!var}" >&2
done
echo >&2

[[ $mod_id == "$mod" ]] ||
  die "The mod '$mod' reports being mod '$mod_id' instead."
[[ $mod_license_key == gpl-3.0 ]] ||
[[ $(echo $(head -2 <(curl "https://raw.githubusercontent.com/$mod_owner/$mod_repo/$mod_rev/COPYING"))) == 'GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007' ]] ||
  die "The mod '$mod' is licensed under '$mod_license_key' while expecting 'gpl-3.0'."
[[ $automatic_engine_management == True ]] ||
  die "The mod '$mod' engine is not managed as a read-only dependency."
[[ $automatic_engine_source =~ https://github.com/([a-zA-Z0-9_\-]+)/([a-zA-Z0-9_\-]+)/archive/([a-zA-Z0-9_\-\$\{\}]+).zip ]] ||
  die "The mod '$mod' engine is not hosted on GitHub as an archive."

engine_owner=${BASH_REMATCH[1]}
engine_repo=${BASH_REMATCH[2]}
[[ ${BASH_REMATCH[3]} == '${ENGINE_VERSION}' ]] || engine_version=${BASH_REMATCH[3]}
engine_rev=$(get_sha1 "$engine_owner" "$engine_repo" "$engine_version")

for type in mod engine; do
  for name in version owner repo rev; do
    var="${type}_${name}"
    echo "$var=${!var}" >&2
  done
  echo >&2
done

i=0
for type in mod engine; do
  fetcher_args=()
  for name in owner repo rev; do
    var="${type}_${name}"
    fetcher_args+=( "--$name" "${!var}" )
  done
  var="${type}_version"
  version=${!var}
  nix-update-fetch --yes --version "$version" "$(nix-prefetch --quiet --file "$nixpkgs" "openraPackages.mods.$mod" --index $i --output json --with-position --diff -- "${fetcher_args[@]}")"
  (( i++ ))
done
