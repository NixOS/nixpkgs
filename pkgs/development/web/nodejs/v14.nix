{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.11.0";
    sha256 = "1sq5j9fpcj0sb9062fik35chkc3lgdbwj56fcza186qsfzrf9iji";
  }
