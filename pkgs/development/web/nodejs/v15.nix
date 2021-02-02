{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "15.8.0";
    sha256 = "1a9h88zdzk98k618jascfrivq3v51viw60sfyxn0ci0l33vf4fp2";
  }
