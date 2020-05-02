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
    version = "14.3.0";
    sha256 = "0xqs9z0pxx8m5dk9gm1r9pxfk9vdmpvfsj94mfdkqar578nfm8gi";
  }
