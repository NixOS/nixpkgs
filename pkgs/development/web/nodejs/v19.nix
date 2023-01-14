{ callPackage, openssl, fetchpatch, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };

in
buildNodejs {
  inherit enableNpm;
  version = "19.4.0";
  sha256 = "0qdj67dgxbjpllm2z9vm46c50s3dqk8a34hbp81vsa7mf3b42182";
  patches = [
    ./revert-arm64-pointer-auth.patch
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
  ];
}
