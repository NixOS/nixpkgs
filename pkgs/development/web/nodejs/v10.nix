{ callPackage, openssl, icu, python2, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { 
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.22.0";
    sha256 = "1nz18fa550li10r0kzsm28c2rvvq61nq8bqdygip0rmvbi2paxg0";
  }
