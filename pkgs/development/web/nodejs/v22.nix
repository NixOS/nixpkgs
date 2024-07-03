{ callPackage, fetchpatch2, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "22.3.0";
  sha256 = "0k0h4s9s2y0ms3g6xhynsqsrkl9hz001dmj6j0gpc5x5vk8mpf5z";
  patches = [
    ./disable-darwin-v8-system-instrumentation-node19.patch
    ./bypass-darwin-xcrun-node16.patch
    ./node-npm-build-npm-package-logic.patch
    ./use-correct-env-in-tests.patch
    ./bin-sh-node-run-v22.patch
    (fetchpatch2 {
      # Fixes OpenSSL 3.0.14 compatibility in tests.
      # See https://github.com/nodejs/node/pull/53373
      url = "https://github.com/nodejs/node/commit/14863e80584e579fd48c55f6373878c821c7ff7e.patch";
      hash = "sha256-I7Wjc7DE059a/ZyXAvAqEGvDudPjxQqtkBafckHCFzo=";
    })
  ];
}
