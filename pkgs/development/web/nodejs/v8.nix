{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "8.11.1";
    sha256 = "12kmsh5cl72dq5hzik1cczn2n5crbfqqd1xmrzqgryipx98yp9j0";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ./no-xcodebuild.patch ];
  }
