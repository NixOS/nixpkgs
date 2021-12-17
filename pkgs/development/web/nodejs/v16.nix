{ callPackage, fetchpatch, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.13.1";
    sha256 = "1bb3rjb2xxwn6f4grjsa7m1pycp0ad7y6vz7v2d7kbsysx7h08sc";
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
