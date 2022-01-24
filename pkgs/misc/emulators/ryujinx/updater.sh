#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils gnused curl common-updater-scripts nuget-to-nix nix-prefetch-git jq dotnet-sdk_6
set -eo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath "./deps.nix")"

nix-prefetch-git https://github.com/ryujinx/ryujinx --quiet > repo_info
new_hash="$(jq -r ".sha256" < repo_info)"
new_rev="$(jq -r ".rev" < repo_info)"
rm repo_info

new_version="$(
    curl -s https://ci.appveyor.com/api/projects/gdkchan/ryujinx/branch/master \
        | grep -Po '"version":.*?[^\\]",' \
        | sed  's/"version":"\(.*\)",/\1/'
    )"
old_version="$(sed -nE 's/\s*version = "(.*)".*/\1/p' ./default.nix)"

if [[ "$new_version" == "$old_version" ]]; then
  echo "Already up to date! Doing nothing"
  exit 0
fi

cd ../../../..
update-source-version ryujinx "$new_version" "$new_hash" --rev="$new_rev"

store_src="$(nix-build . -A ryujinx.src --no-out-link)"
src="$(mktemp -d /tmp/ryujinx-src.XXX)"
cp -rT "$store_src" "$src"
chmod -R +w "$src"
pushd "$src"

mkdir nuget_tmp.packages
dotnet restore Ryujinx.sln --packages nuget_tmp.packages

nuget-to-nix ./nuget_tmp.packages > "$deps_file"

popd
rm -r "$src"
