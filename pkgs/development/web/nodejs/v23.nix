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
  version = "23.6.1";
  sha256 = "fefa49dede8733018ada4e30f885808cc4e22167b8ae3233c6d6a23737aff76f";
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
      url = "https://github.com/nodejs/node/commit/d0ff34f4b690ad49c86b6df8fd424f39d183e1a6.patch?full_index=1";
      hash = "sha256-ezcCrg7UwK091pqYxXJn4ay9smQwsrYeMO/NBE7VaM8=";
    })
    # test-icu-env is failing on ICU 74.2
    # FIXME: remove once https://github.com/nodejs/node/pull/56661 is included in a next release
    (fetchpatch2 {
      url = "https://github.com/nodejs/node/commit/a364ec1d1cbbd5a6d20ee54d4f8648dd7592ebcd.patch?full_index=1";
      hash = "sha256-EL1NgCBzz5O1spwHgocLm5mkORAiqGFst0N6pc3JvFg=";
      revert = true;
    })
  ];
}
