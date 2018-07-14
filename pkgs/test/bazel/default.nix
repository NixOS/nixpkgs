{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  name = "bazel-test";

  # Getting the error:
  # /tmp/.bazel-619/.bazel/962e61887c2adf20fb3a0a8cd817313c/execroot/nix_test/bazel-out/host/bin/external/bazel_gazelle/cmd/gazelle/linux_amd64_stripped/gazelle: error while loading shared libraries: libstdc++.so.6: cannot open shared object file: No such file or directory
  # TODO: fix this!
  buildInputs = with pkgs; [ bazel python2Full python3Full git cacert ];

  src = ./.;

  buildPhase = ''
    echo pwd >> /tmp/log
    pwd >> /tmp/log
    echo ls -la >> /tmp/log
    ls -la >> /tmp/log

    export TMPDIR=/tmp/.bazel-$UID

    echo "startup --batch --output_user_root=$TMPDIR/.bazel" > .bazelrc

    printf "running bazel run //:gazelle " >&2
    bazel run //:gazelle

    printf "running bazel test //... " >&2
    bazel test //...
  '';
}
