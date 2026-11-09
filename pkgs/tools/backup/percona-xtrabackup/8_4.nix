{ callPackage, fetchpatch, ... }@args:

callPackage ./generic.nix (
  args
  // {
    version = "8.4.0-7";
    hash = "sha256-cDMWnk7SOZKnkjf+QVNAh69anr9Q9OSG89nm85tRhao=";

    # includes https://github.com/Percona-Lab/libkmip.git
    fetchSubmodules = true;

    extraPatches = [
      # Fix build with GCC16
      (fetchpatch {
        url = "https://github.com/percona/percona-xtrabackup/commit/024437d597e92c950faa4efa59429ee2e801dd58.patch";
        hash = "sha256-BRVDDgaiekCJ5OMdzh5O1FIOn+ACor2HilK3gt3Jw94=";
        excludes = [
          "router/src/mysql_rest_service/src/mrs/authentication/helper/scram.h"
        ];
      })
      (fetchpatch {
        url = "https://github.com/percona/percona-xtrabackup/commit/c03c65750311b84167652a211b8f7ac50b68de9b.patch";
        hash = "sha256-MIMY5BavSYpiCXiSVT4PoVpCgf30ve17Z2oXLGs1d8Y=";
      })
    ];

    extraPostInstall = "";
  }
)
