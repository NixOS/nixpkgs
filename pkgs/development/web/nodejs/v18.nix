{ callPackage, fetchpatch, openssl, python3, enableNpm ? true }:

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

    (fetchpatch {
      url = "https://salsa.debian.org/js-team/nodejs/-/raw/master/debian/patches/riscv/fix-ftbfs-riscv64-18-13-0.patch";
      sha256 = "sha256-1hd0oJY9aIoKkL7WHHPlcbLunF89J7J197silc2sExE=";
    })
  ] ++ npmPatches;
}
