{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.0.0";
    sha256 = "00mada0vvybizygwhzsq6gcz0m2k864lfiiqqlnw8gcc3q8r1js7";
  }
