{ callPackage, openssl, icu, python2, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { 
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.18.1";
    sha256 = "0yjwd8yilm85wkginvhhchcikjsl8g3l3qagbg0l2y1hg8f0anfa";
  }
