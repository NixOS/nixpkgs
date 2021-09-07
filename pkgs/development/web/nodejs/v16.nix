{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.9.0";
    sha256 = "0vv6igmnz4fkr4i8gczxxw2qgcvydkpy71w3lskah8zw1lh69rqs";
    patches = [ ./disable-darwin-v8-system-instrumentation.patch ];
  }
