{ callPackage, openssl, icu, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "13.14.0";
    sha256 = "1gi9nl99wsiqpwm266jdsa8g6rmjw4wqwgrkx9f2qk1y3hjcs0vf";
  }
