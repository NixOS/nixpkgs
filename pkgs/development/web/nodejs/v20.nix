{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

in
buildNodejs {
  inherit enableNpm;
  version = "20.3.1";
  sha256 = "sha256-EqgtswZpeVm0OJs1Gl+XhImGsTE/mQGw4LPYz08/mZE=";
  patches = [
    ./revert-arm64-pointer-auth.patch
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
  ];
}
