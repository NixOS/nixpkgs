{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.8.0";
    sha256 = "14k3njj382im3q4k6dhsxdk07gs81hw2k0nrixfvlw1964k04ydq";
    patches = [ ./disable-darwin-v8-system-instrumentation.patch ];
  }
