{ callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.16.0";
    sha256 = "09grij355z210mkzkzarb6gwz8b02lnaxzdll1249kiz8wvhdjdq";
  }
