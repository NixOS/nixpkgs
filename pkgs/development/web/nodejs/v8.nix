{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "8.9.4";
    sha256 = "0vy8rlg58kg75j4sw3xadmbrwxfa56iaykmjl18g9a8wkjfdxp3c";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ];
  }
