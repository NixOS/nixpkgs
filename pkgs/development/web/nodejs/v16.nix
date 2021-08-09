{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.6.1";
    sha256 = "0mz5wfhf2k1qf3d57h4r8b30izhyg93g5m9c8rljlzy6ih2ymcbr";
  }
