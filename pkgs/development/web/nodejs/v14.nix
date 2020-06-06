{ callPackage, openssl, icu66, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    icu = icu66;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.4.0";
    sha256 = "1fbx1r3fflpsy0s7zknca0xyv2gg0ff5fl8czzsb79imqjlgcy0x";
  }
