{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.2.0";
    sha256 = "1krm3cnpbnqg4mfl3cpp8x2i1rr6hba9qbl60wyg5f5g8ac3pyfh";
  }
