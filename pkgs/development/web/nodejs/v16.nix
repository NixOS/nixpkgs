{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.3.0";
    sha256 = "0pxcdy9i1iyxp4afmpaz30ajlwrj74y64jl3n9rjqw0r5jw4gavs";
  }
