{ callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.16.1";
    sha256 = "0ba1dla31z6i31z3723l74nky1v04irwbl3iaqmi0iicl1dq958a";
  }
