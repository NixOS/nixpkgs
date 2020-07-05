{ callPackage, openssl, icu, python2, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { 
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.18.2";
    sha256 = "1wnxab2shqgs5in0h39qy2fc7f32pcz4gl9i2mj1001pfani1g9q";
  }
