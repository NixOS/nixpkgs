{ callPackage, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "18.7.0";
  sha256 = "sha256-iDSjPJLf5rqJA+ZxXK6qJd/0ZX5wPFTNBuwRNJPiw8I=";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
  ];
}
