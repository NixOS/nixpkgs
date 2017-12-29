{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "9.2.0";
    sha256 = "1hmvwfbavk2axqz9kin8b5zsld25gznhvlz55h3yl6nwx9iz5jk4";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ];
  }
