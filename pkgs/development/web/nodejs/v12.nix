{ callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.5.0";
    sha256 = "08haqs104lw44l92bxfii18sdn7y1k07cz3p0ni9bhw7kh4vf5c7";
  }
