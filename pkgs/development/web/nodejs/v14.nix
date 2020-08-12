{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.8.0";
    sha256 = "0vghz7g7mih7idgknwzdc2zfw82qqq497m727ydhkas1wvj6i7lv";
  }
