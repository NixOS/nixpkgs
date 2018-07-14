{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  name = "bazel-test";

  buildInputs = with pkgs; [ bazel python2Full python3Full ];

  src = ./.;

  buildPhase = ''
    echo pwd >> /tmp/log
    pwd >> /tmp/log
    echo ls -la >> /tmp/log
    ls -la >> /tmp/log

    export TMPDIR=/tmp/.bazel-$UID

    printf "running bazel //:gazelle... " >&2
    bazel --output_user_root=$TMPDIR/.bazel run //:gazelle
  '';
}
