{ callPackage, openssl, icu, python2, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.23.0";
    sha256 = "07vlqr0493a569i0npwgkxk5wa4vc7j68jsivchg08y2slwn0dgx";
  }
