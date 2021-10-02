{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.10.0";
    sha256 = "04krpy0r8msv64rcf0vy2l2yzf0a401km8p5p7h12j9b4g51mp4p";
    patches = [ ./disable-darwin-v8-system-instrumentation.patch ];
  }
