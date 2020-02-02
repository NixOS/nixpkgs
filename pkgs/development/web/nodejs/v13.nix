{ callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "13.7.0";
    sha256 = "1fql5858aqny8krrqrgdp97kfia8xv0jlviwnm3akmv8i1i6xqkh";
  }
