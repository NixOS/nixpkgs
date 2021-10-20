{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.11.1";
    sha256 = "0y32mdv8zs35la2bny8d9rxjvj1vr8z079ji1g6ajc2yw96pyn37";
    patches = [ ./disable-darwin-v8-system-instrumentation.patch ];
  }
