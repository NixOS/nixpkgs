{ callPackage, python3, lib, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.18.2";
    sha256 = "02v8rjwm8492w91rfvxy369bm11wy3vlkl3dxcl3dkcb1zhrr2iy";
    patches = lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
