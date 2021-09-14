{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.9.1";
    sha256 = "070k8i9a65r03xdchr200qixv053mim5irfvgg4pl3h57k2hxxcp";
    patches = [ ./disable-darwin-v8-system-instrumentation.patch ];
  }
