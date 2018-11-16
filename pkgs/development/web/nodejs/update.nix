{ lib
, writeScript
, coreutils
, curl
, gnugrep
, jq
, gnupg
, common-updater-scripts
, majorVersion
, nix
}:

writeScript "update-nodejs" ''
  PATH=${lib.makeBinPath [ common-updater-scripts coreutils curl gnugrep jq gnupg nix ]}

  HOME=`mktemp -d`
  cat ${./nodejs-release-keys.asc} | gpg --import

  tags=`curl --silent https://api.github.com/repos/nodejs/node/git/refs/tags`
  version=`echo $tags | jq -r '.[] | select(.ref | startswith("refs/tags/v${majorVersion}")) | .ref' | sort --version-sort  | tail -1 | grep -oP "^refs/tags/v\K.*"`

  curl --silent -o $HOME/SHASUMS256.txt.asc https://nodejs.org/dist/v''${version}/SHASUMS256.txt.asc
  hash_hex=`gpgv --keyring=$HOME/.gnupg/pubring.kbx --output - $HOME/SHASUMS256.txt.asc | grep -oP "^([0-9a-f]{64})(?=\s+node-v''${version}.tar.xz$)"`
  hash=`nix-hash --type sha256 --to-base32 ''${hash_hex}`

  update-source-version nodejs-${majorVersion}_x "''${version}" "''${hash}"
''
