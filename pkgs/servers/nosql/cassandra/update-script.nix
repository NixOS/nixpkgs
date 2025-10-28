{
  git,
  lib,
  runtimeShell,
  writeScript,
  generation,
  gnupg,
}:
let
  inherit (lib) makeBinPath;
  filename = lib.strings.replaceStrings [ "_" ] [ "." ] generation + ".json";
  regex = lib.strings.replaceStrings [ "_" ] [ "[.]" ] generation;
in
writeScript "update-cassandra_${generation}" ''
  #!${runtimeShell}
  set -eux -o pipefail
  test -d pkgs -a -d nixos -a -d lib || {
    echo >&2 "$0 expects to be run in a nixpkgs checkout"
    exit 1
  }
  cd pkgs/servers/nosql/cassandra
  PATH="${
    makeBinPath [
      git
      gnupg
    ]
  }:$PATH"

  tmp="$(mktemp -d)"
  cleanup() {
    rm -rf "$tmp"
  }
  trap cleanup EXIT

  # get numeric-only versions, sort them latest first
  git ls-remote --tags https://github.com/apache/cassandra \
    | awk '{ if (match($0, /refs.tags.cassandra-([0-9.]*)$/, m)) print m[1] }' \
    | sort -V \
    | tac >$tmp/versions

  version="$(grep -E '^${regex}' <$tmp/versions | head -n 1)"
  path="cassandra/$version/apache-cassandra-$version-bin.tar.gz"
  curl "https://downloads.apache.org/$path" >$tmp/src.tar.gz
  curl "https://downloads.apache.org/$path.asc" >$tmp/src.tar.gz.asc

  # See https://downloads.apache.org/cassandra/KEYS
  # Make sure that any new key corresponds to someone on the project
  for key in A4C465FEA0C552561A392A61E91335D77E3E87CB; do
    gpg --trustdb-name "$tmp/trust.db" --batch --recv-keys "$key"
    echo "$key:5:" | gpg --trustdb-name "$tmp/trust.db" --batch --import-ownertrust
  done
  gpg --trustdb-name "$tmp/trust.db" --batch --verify --trust-model direct $tmp/src.tar.gz.asc $tmp/src.tar.gz

  hash="$(nix-prefetch-url "file://$tmp/src.tar.gz")"
  cat >${filename} <<EOF
  {
    "version": "$version",
    "sha256": "$hash"
  }
  EOF
''
