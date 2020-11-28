{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "15.0.1";
    sha256 = "03xxnl7q96fmm7lalliwb9kmllz52jqrcsqn9cx9pzhwd1x97l5q";
  }
