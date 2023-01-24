{ callPackage, openssl, fetchpatch, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

in
buildNodejs {
  inherit enableNpm;
  version = "19.5.0";
  sha256 = "sha256-KBMXvce6iVITi/jw9fB2SV95+G6FGmWb4fmD3sM8pXc=";
  patches = [
    ./revert-arm64-pointer-auth.patch
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
  ];
}
