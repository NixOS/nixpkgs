{
  lib
  ,writeShellScript
  ,coreutils
  ,jq
  ,common-updater-scripts
  ,curl
  ,wget
  ,gnugrep
  ,yarn
  ,nix-prefetch
  ,prefetch-yarn-deps
}:
writeShellScript "update-keyoxide-web" ''
  set -xe
  export PATH="${lib.makeBinPath [ gnugrep coreutils curl wget jq common-updater-scripts yarn prefetch-yarn-deps ]}:$PATH"

  cd pkgs/servers/web-apps/keyoxide-web/

  owner="keyoxide"
  pname="keyoxide-web"

  oldVersion=`nix-instantiate --eval -E "with import ../../../.. {}; lib.getVersion keyoxide-web" | tr -d '"'`
  newVersion=`curl -s "https://codeberg.org/api/v1/repos/$owner/$pname/releases?limit=1" | jq -r '.[0].tag_name'`

  if [ ! "$oldVersion" = "$newVersion" ]; then
    url="https://codeberg.org/$owner/$pname/archive/$newVersion.tar.gz";
    echo $newVersion > version

    mkdir $pname
    curl -s $url | tar -xz --directory $pname --strip-components=1
    echo $(nix-hash --base32 --type sha256 $pname/) > package-hash
    echo $(prefetch-yarn-deps $pname/yarn.lock) > deps-hash

    rm -rf $pname
  else
    echo "keyoxide-web has already been updated!"
  fi
''

