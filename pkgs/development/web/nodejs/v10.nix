{ callPackage, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.16.3";
    sha256 = "1gbblbmvx7a0wkgp3fs2pf5c1hymdpnfc7zqp1slg5hmfhyi5wbv";
  }
