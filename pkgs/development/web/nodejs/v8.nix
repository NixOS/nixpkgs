{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "8.11.2";
    sha256 = "0ya9iz47d7ld4zb0aqym9cpxah0pzhsllhh7xmmmf28q7304d6ak";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ./no-xcodebuild.patch ];
  }
