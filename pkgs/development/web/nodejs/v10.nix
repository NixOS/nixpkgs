{ callPackage, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.20.0";
    sha256 = "0cvjwnl0wkcsyw3kannbdv01s235wrnp11n2s6swzjx95gpichfi";
  }
