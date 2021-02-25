{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "15.10.0";
    sha256 = "1i7fdlkkyh5ssncbvxmiz894a12mww4cmj7y4qzm9ddbbvqxhj3p";
  }
