{ callPackage, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "17.7.2";
  sha256 = "sha256-OuXnTgsWIoz37faIU1mp0uAZrIQ5BsXgGUjXRvq6Sq8=";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
  ];
}
