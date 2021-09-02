{ callPackage, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.17.6";
    sha256 = "0pmd0haav2ychhcsw44klx6wfn8c7j1rsw08rc8hcm5i3h5wsn7l";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
