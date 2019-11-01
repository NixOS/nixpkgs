{ callPackage, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.17.0";
    sha256 = "13n5cvb340ba7vwm8il7bjrmpz89h6cibhk9rc3kq9ymdgbnf9j1";
  }
