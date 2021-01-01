{ callPackage, openssl, icu, python2, stdenv, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.18.4";
    sha256 = "02gncjrrjqdwf9ydmg96yn9ldsw539q9w88cknax1djkisqkrw15";
    patches = stdenv.lib.optional stdenv.isDarwin ./bypass-xcodebuild.diff;
  }
