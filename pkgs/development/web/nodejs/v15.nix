{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "15.2.1";
    sha256 = "0gp8z68h888x2ql64aiicgs7k065lg755cbjlnkbzdih5bh32qjn";
  }
