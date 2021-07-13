{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.4.2";
    sha256 = "048x4vznpi6dai6fripg0yk21kfxm9s2mw7jb0rzisyv5aw8v2dj";
  }
