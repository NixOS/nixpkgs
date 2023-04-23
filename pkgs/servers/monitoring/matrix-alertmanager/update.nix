{ lib, writeShellScript
, coreutils, jq, common-updater-scripts
, curl, wget, gnugrep, yarn, prefetch-yarn-deps
}:

writeShellScript "update-matrix-alertmanager" ''
  set -xe
  export PATH="${lib.makeBinPath [ gnugrep coreutils curl wget jq common-updater-scripts yarn prefetch-yarn-deps ]}"

  cd pkgs/servers/monitoring/matrix-alertmanager/

  owner="jaywink"
  repo="matrix-alertmanager"
  version=`curl -s "https://api.github.com/repos/$owner/$repo/tags" | jq -r .[0].name | grep -oP "^v\K.*"`
  url="https://raw.githubusercontent.com/$owner/$repo/v$version/"

  (
    cd ../../../..
    update-source-version matrix-alertmanager "$version" --file=pkgs/servers/monitoring/matrix-alertmanager/default.nix
  )

  rm -f package.json package-lock.json yarn.lock
  wget "$url/package.json" "$url/package-lock.json"

  yarn import
  echo $(prefetch-yarn-deps) > yarn-hash

  jq '. + { bin: .main }' package.json > package.json.tmp
  mv package.json{.tmp,}

  rm -rf package-lock.json node_modules
''
