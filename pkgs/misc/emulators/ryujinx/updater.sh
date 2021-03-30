#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils gnused curl common-updater-scripts nix-prefetch-git jq dotnet-sdk_5
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

# Setup empty nuget package folder to force reinstall.
mkdir ./nuget_tmp.packages
cat >./nuget_tmp.config <<EOF
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <add key="nuget" value="https://api.nuget.org/v3/index.json" />
  </packageSources>
  <config>
    <add key="globalPackagesFolder" value="$(realpath ./nuget_tmp.packages)" />
  </config>
</configuration>
EOF

dotnet restore Ryujinx.sln --configfile ./nuget_tmp.config

echo "{ fetchNuGet }: [" >"$deps_file"
while read pkg_spec; do
  { read pkg_name; read pkg_version; } < <(
    # Build version part should be ignored: `3.0.0-beta2.20059.3+77df2220` -> `3.0.0-beta2.20059.3`
    sed -nE 's/.*<id>([^<]*).*/\1/p; s/.*<version>([^<+]*).*/\1/p' "$pkg_spec")
  pkg_sha256="$(nix-hash --type sha256 --flat --base32 "$(dirname "$pkg_spec")"/*.nupkg)"
  cat >>"$deps_file" <<EOF
  (fetchNuGet {
    name = "$pkg_name";
    version = "$pkg_version";
    sha256 = "$pkg_sha256";
  })
EOF
done < <(find ./nuget_tmp.packages -name '*.nuspec' | sort)
echo "]" >>"$deps_file"

popd
rm -r "$src"
