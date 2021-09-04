{ lib, writeShellScript
, coreutils, jq, common-updater-scripts
, curl, wget, gnugrep, yarn, yarn2nix
}:

writeShellScript "update-matrix-alertmanager" ''
  set -xe
  export PATH="${lib.makeBinPath [ gnugrep coreutils curl wget jq common-updater-scripts yarn yarn2nix ]}"

  cd ${toString ./.}

  cd $(dirname $0)

  domain="git.feneas.org"
  owner="jaywink"
  repo="matrix-alertmanager"
  version=`curl --silent https://$domain/api/v4/projects/jaywink%2Fmatrix-alertmanager/repository/tags | jq -r '.[0].name' | grep -oP "^v\K.*"`
  url="https://$domain/$owner/$repo/-/raw/v$version/"

  (
    cd ../../../..
    update-source-version matrix-alertmanager "$version" --file=pkgs/servers/monitoring/matrix-alertmanager/default.nix
  )

  rm -f package.json package-lock.json yarn.lock yarn.nix
  wget "$url/package.json" "$url/package-lock.json"

  yarn import
  yarn2nix > yarn.nix

  jq '. + { bin: .main }' package.json > package.json.tmp
  mv package.json{.tmp,}

  rm -rf package-lock.json node_modules
''
