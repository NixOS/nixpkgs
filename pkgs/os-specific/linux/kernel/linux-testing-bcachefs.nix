{ lib
, stdenv
, fetchpatch
, kernel
, commitDate ? "2023-05-02"
# bcachefs-tools stores the expected-revision in:
#   https://evilpiepirate.org/git/bcachefs-tools.git/tree/.bcachefs_revision
# but this does not means that it'll be the latest-compatible revision
, currentCommit ? "6a20aede294f72f3920146a352aa102a9fd3d0aa"
, diffHash ? "sha256-IGOsZm3SdWUf6DNVQiDMRGoyKNIPvwSwN0jgktRTVbk="

, kernelPatches # must always be defined in bcachefs' all-packages.nix entry because it's also a top-level attribute supplied by callPackage
, argsOverride ? {}
, ...
} @ args:

# NOTE: bcachefs-tools should be updated simultaneously to preserve compatibility
(kernel.override ( args // {
  version = "${kernel.version}-bcachefs-unstable-${commitDate}";

  extraMeta = {
    branch = "master";
    broken = stdenv.isAarch64;
    maintainers = with lib.maintainers; [ davidak Madouura pedrohlc ];
  };

  kernelPatches = [ {
      name = "bcachefs-${currentCommit}";

      patch = fetchpatch {
        name = "bcachefs-${currentCommit}.diff";
        url = "https://evilpiepirate.org/git/bcachefs.git/rawdiff/?id=${currentCommit}&id2=v${lib.versions.majorMinor kernel.version}";
        sha256 = diffHash;
      };

      extraConfig = "BCACHEFS_FS m";
    } ] ++ kernelPatches;
}))
