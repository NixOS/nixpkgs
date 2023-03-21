{ lib
, stdenv
, fetchpatch
, kernel
, commitDate ? "2023-02-01"
, currentCommit ? "65960c284ad149cc4bfbd64f21e6889c1e3d1c5f"
, diffHash ? "sha256-4wpY3aYZ93OXSU4wmQs9K62nPyIzjKu4RBQTwksmyyk="

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
