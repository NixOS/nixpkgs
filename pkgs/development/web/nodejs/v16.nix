{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.6.2";
    sha256 = "1svrkm2zq8dyvw2l7gvgm75x2fqarkbpc33970521r3iz6hwp547";
    patches = [ ./disable-darwin-v8-system-instrumentation.patch ];
  }
