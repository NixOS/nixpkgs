{ callPackage, fetchpatch }:

let
  common = callPackage ./common.nix { };
in
{
  mir = common {
    version = "2.18.2";
    hash = "sha256-Yko5ws8dUazPziXzM77Zg4p1taC0mbjAcpOKJR0dJ5M=";
  };

  mir_2_15 = common {
    version = "2.15.0";
    pinned = true;
    hash = "sha256-c1+gxzLEtNCjR/mx76O5QElQ8+AO4WsfcG7Wy1+nC6E=";
    patches = [
      # Fix gbm-kms tests
      # Remove when version > 2.15.0
      (fetchpatch {
        name = "0001-mir-Fix-the-signature-of-drmModeCrtcSetGamma.patch";
        url = "https://github.com/canonical/mir/commit/98250e9c32c5b9b940da2fb0a32d8139bbc68157.patch";
        hash = "sha256-tTtOHGNue5rsppOIQSfkOH5sVfFSn/KPGHmubNlRtLI=";
      })
      # Fix external_client tests
      # Remove when version > 2.15.0
      (fetchpatch {
        name = "0002-mir-Fix-cannot_start_X_Server_and_outdated_tests.patch";
        url = "https://github.com/canonical/mir/commit/0704026bd06372ea8286a46d8c939286dd8a8c68.patch";
        hash = "sha256-k+51piPQandbHdm+ioqpBrb+C7Aqi2kugchAehZ1aiU=";
      })
    ];
  };
}
