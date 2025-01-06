{
  callPackage,
  fetchpatch2,
  openssl,
  python3,
  enableNpm ? true,
}:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "23.5.0";
  sha256 = "32e77b36c0774c68baab41bc7c2acc58663ca0a2b7c4d3e9bec6f761c15fdac0";
  patches = [
    ./configure-emulator.patch
    ./configure-armv6-vfpv2.patch
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
    ./use-correct-env-in-tests.patch
    ./bin-sh-node-run-v22.patch

    # FIXME: remove after a minor point release
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/49acdc8748fe9fe83bc1b444e24c456dff00ecc5.patch?full_index=1";
      hash = "sha256-iK7bj4KswTeQ9I3jJ22ZPTsvCU8xeGGXEOo43dxg3Mk=";
    })
  ];
}
