{ callPackage, fetchpatch }:

let
  common = callPackage ./common.nix { };
in
{
  mir = common {
    version = "2.19.3";
    hash = "sha256-WwT0cdLZJlVTTq8REuQrtYWdpRhqEDjYPHDy2oj8Edk=";
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

      # Always depend on epoxy
      # Remove when version > 2.15.0
      (fetchpatch {
        name = "0003-mir-cmake-always-require-epoxy.patch";
        url = "https://github.com/canonical/mir/commit/171c42ac3929f946a70505ee42be0ce8220f245a.patch";
        hash = "sha256-QuVZBcHSn/DK+xbjM36Y89+w22vk7NRV4MkbjgvS28A=";
      })

      # Fix ignored return value of std::lock_guard
      # Remove when version > 2.15.0
      # Was changed as part of the big platform API change, no individual upstream commit with this fix
      ./1001-mir-2_15-Fix-ignored-return-value-of-std-lock_guard.patch

      # Fix missing includes for methods from algorithm
      # Remove when version > 2.16.4
      # https://github.com/canonical/mir/pull/3191 backported to 2.15
      ./1002-mir-2_15-Add-missing-includes-for-algorithm.patch

      # Fix order of calloc arguments
      # Remove when version > 2.16.4
      # Partially done in https://github.com/canonical/mir/pull/3192, though one of the calloc was fixed earlier
      # when some code was moved into that file
      ./1003-mir-2_15-calloc-args-in-right-order.patch

      # Drop gflags & glog dependencies
      # Remove when version > 2.16.4
      (fetchpatch {
        name = "0101-Drop-unused-dependency-on-gflags.patch";
        url = "https://github.com/canonical/mir/commit/15a40638e5e9c4b6a11b7fa446ad31e190f485e7.patch";
        includes = [
          "CMakeLists.txt"
          "examples/mir_demo_server/CMakeLists.txt"
          "examples/mir_demo_server/glog_logger.cpp"
        ];
        hash = "sha256-qIsWCOs6Ap0jJ2cpgdO+xJHmSqC6zP+J3ALAfmlA6Vc=";
      })
      (fetchpatch {
        name = "0102-Drop-the-glog-example.patch";
        url = "https://github.com/canonical/mir/commit/8407da28ddb9a535df2775f224bf5143e8770d52.patch";
        includes = [
          "CMakeLists.txt"
          "examples/mir_demo_server/CMakeLists.txt"
          "examples/mir_demo_server/glog_logger.cpp"
          "examples/mir_demo_server/glog_logger.h"
          "examples/mir_demo_server/server_example.cpp"
          "examples/mir_demo_server/server_example_log_options.cpp"
          "examples/mir_demo_server/server_example_log_options.h"
        ];
        hash = "sha256-jVhVR7wZZZGRS40z+HPNoGBLHulvE1nHRKgYhQ6/g9M=";
      })
    ];
  };
}
