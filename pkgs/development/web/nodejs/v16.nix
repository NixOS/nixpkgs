{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.13.1";
    sha256 = "1bb3rjb2xxwn6f4grjsa7m1pycp0ad7y6vz7v2d7kbsysx7h08sc";
    patches = [ ./disable-darwin-v8-system-instrumentation.patch ];
  }
