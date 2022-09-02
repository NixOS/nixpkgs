{ callPackage, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "18.8.0";
  sha256 = "sha256-K12YJdBe3mYU8WaKjZfXdP6S68gQiOxf31gYTc48hrk=";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
  ];
}
