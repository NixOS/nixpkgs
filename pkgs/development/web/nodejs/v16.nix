{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.11.0";
    sha256 = "1bk5f47hm409129w437h8qdvmqjdr11awblvnhkfsp911nyk3xnk";
    patches = [ ./disable-darwin-v8-system-instrumentation.patch ];
  }
