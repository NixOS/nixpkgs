{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "8.9.4";
    sha256 = "0vy8rlg58kg75j4sw3xadmbrwxfa56iaykmjl18g9a8wkjfdxp3c";
    headersSha256 = "1993kcghzr56zmw5sdj8wr8c42mna25806bcjknfxnh62zl4hwpg";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ./no-xcodebuild.patch ];
  }
