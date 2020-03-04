{ callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "13.10.0";
    sha256 = "11m8sisi3dmr70fpnb7xi6nljil3rm36liz0wfzd7kgxmv6p9mhj";
  }
