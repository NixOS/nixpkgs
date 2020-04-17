{ callPackage, openssl, icu, python2, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { 
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.16.2";
    sha256 = "0y5yd6h13fr34byi7h5xdjaivgcxiz0ykcmpk9nm5ra01b54fp2m";
  }
