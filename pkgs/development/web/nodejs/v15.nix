{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "15.12.0";
    sha256 = "0c8smzc7gbr7yg4y4z68976wk5741bspggag9h9laykq4i8bxfsy";
  }
