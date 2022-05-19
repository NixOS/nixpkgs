{ callPackage, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "18.2.0";
  sha256 = "sha256-IwWxXr9VR0dOkFtQAvm6mcfu7wHXOU3+bzhGzGvK1m0=";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
  ];
}
