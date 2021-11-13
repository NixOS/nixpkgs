{ callPackage, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "17.0.1";
  sha256 = "071lhqbn103rnn8avqmqwnn2k4yqgcymx624f23k8z6bfbw81i3f";
  patches = [ ./disable-darwin-v8-system-instrumentation.patch ];
}
