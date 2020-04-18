{ callPackage, openssl, icu, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { 
    inherit openssl icu;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "13.13.0";
    sha256 = "0wy7d2alli59gwl73hpaf3bz1wxkkcw5yjsgyz42695fz86p64b7";
  }
