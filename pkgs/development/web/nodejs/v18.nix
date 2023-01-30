{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

  npmPatches = callPackage ./npm-patches.nix { };
in
buildNodejs {
  inherit enableNpm;
  version = "18.13.0";
  sha256 = "0s6sscynhw9limpp43f965rn9grdamcvsnd9wfb2h5qxw1icajpx";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
    ./bypass-darwin-xcrun-node16.patch
  ] ++ npmPatches;
}
