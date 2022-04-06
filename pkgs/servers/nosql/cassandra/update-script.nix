{ git
, lib
, runtimeShell
, writeScript
, generation
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
  PATH="${makeBinPath [git]}:$PATH"

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
  hash="$(nix-prefetch-url "mirror://apache/cassandra/$version/apache-cassandra-$version-bin.tar.gz")"
  cat >${filename} <<EOF
  {
    "version": "$version",
    "sha256": "$hash"
  }
  EOF
''
