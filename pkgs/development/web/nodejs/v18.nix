{ callPackage, fetchpatch, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "18.18.0";
  sha256 = "sha256-5NTbrDY02Z+JLwDbR9p4+YSTwzlYLoqV+y3Vn1z+D5A=";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
    ./bypass-darwin-xcrun-node16.patch
    ./revert-arm64-pointer-auth.patch
    ./node-npm-build-npm-package-logic.patch
    ./trap-handler-backport.patch
  ];
}
