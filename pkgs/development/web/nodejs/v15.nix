{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "15.5.0";
    sha256 = "1wzcypb1kawc6m5q36cd31qjg7ljby8py9qg555m4bqm5gpvvfjg";
  }
