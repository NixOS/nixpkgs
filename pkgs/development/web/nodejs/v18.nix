{ callPackage, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "18.1.0";
  sha256 = "0zhb61ihzslmpl1g3dd6vcxjccc8gwj1v4hfphk7f3cy10hcrc78";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
  ];
}
