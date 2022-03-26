{ callPackage, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "17.8.0";
  sha256 = "0jsf6sv42rzpizvil7g1gf9bskh8lx0gcxg0yzpr4hk7mx7i90br";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
  ];
}
