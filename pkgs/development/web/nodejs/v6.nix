{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "6.13.0";
    sha256 = "012dpfqxsrmd3xc4dmq0mik1kab4czf56s8wm2jvm7xjqvi6y5mp";
    headersSha256 = "0lmmy1gz3xkisp5i3yqxc1z1sj57qp08g6jwcp9if65gr8xjcnqw";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode.patch ./no-xcodebuild.patch ];
  }
