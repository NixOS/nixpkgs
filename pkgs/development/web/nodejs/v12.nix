{ callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.7.0";
    sha256 = "1l7z07j7p2mv70jmhnscgcygvzbd78a19aqs506rivkgljcab6id";
  }
