{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "9.7.1";
    sha256 = "0hlhj817s5bji2qdghxkwxjj40kwkyzgax4zyv32r5pbl6af3yh6";
    headersSha256 = "1c8rjrbvb3g2n2cp2lcnxhy96q5bxm6prq6kh4jscn4p373gyxgi";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ];
  }
