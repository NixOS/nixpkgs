{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "9.10.1";
    sha256 = "1widvxbc8sp8p8vp7q38b3zy0w1nx4iaqmp81s6bvaqs08h7wfy9";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ];
  }
