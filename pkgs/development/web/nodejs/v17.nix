{ callPackage, fetchpatch, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    python = python3;
  };
in
buildNodejs {
  inherit enableNpm;
  version = "17.2.0";
  sha256 = "16k5kqanfvsnickkrv0vz072qg4ddzrk4is56yvdg2f1brxwqirb";
  patches = [
    ./disable-darwin-v8-system-instrumentation.patch
    # Fixes node incorrectly building vendored OpenSSL when we want system OpenSSL.
    # https://github.com/nodejs/node/pull/40965
    (fetchpatch {
      url = "https://github.com/nodejs/node/commit/65119a89586b94b0dd46b45f6d315c9d9f4c9261.patch";
      sha256 = "sha256-dihKYEdK68sQIsnfTRambJ2oZr0htROVbNZlFzSAL+I=";
    })
  ];
}
