{ lib
, stdenv
, fetchpatch
, kernel
<<<<<<< HEAD
, commitDate ? "2023-06-28"
# bcachefs-tools stores the expected-revision in:
#   https://evilpiepirate.org/git/bcachefs-tools.git/tree/.bcachefs_revision
# but this does not means that it'll be the latest-compatible revision
, currentCommit ? "84f132d5696138bb038d2dc8f1162d2fab5ac832"
, diffHash ? "sha256-RaBWBU7rXjJFb1euFAFBHWCBQAG7npaCodjp/vMYpyw="
=======
, commitDate ? "2023-02-01"
, currentCommit ? "65960c284ad149cc4bfbd64f21e6889c1e3d1c5f"
, diffHash ? "sha256-4wpY3aYZ93OXSU4wmQs9K62nPyIzjKu4RBQTwksmyyk="

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ davidak Madouura pedrohlc raitobezarius ];
  };

  structuredExtraConfig = with lib.kernel; {
    BCACHEFS_FS = module;
    BCACHEFS_QUOTA = option yes;
    BCACHEFS_POSIX_ACL = option yes;
=======
    maintainers = with lib.maintainers; [ davidak Madouura pedrohlc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  kernelPatches = [ {
      name = "bcachefs-${currentCommit}";

      patch = fetchpatch {
        name = "bcachefs-${currentCommit}.diff";
        url = "https://evilpiepirate.org/git/bcachefs.git/rawdiff/?id=${currentCommit}&id2=v${lib.versions.majorMinor kernel.version}";
        sha256 = diffHash;
      };
<<<<<<< HEAD
=======

      extraConfig = "BCACHEFS_FS m";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    } ] ++ kernelPatches;
}))
