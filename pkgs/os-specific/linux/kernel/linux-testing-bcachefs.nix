{ lib
, stdenv
, fetchpatch
, kernel
, commitDate ? "2023-06-28"
# bcachefs-tools stores the expected-revision in:
#   https://evilpiepirate.org/git/bcachefs-tools.git/tree/.bcachefs_revision
# but this does not means that it'll be the latest-compatible revision
, currentCommit ? "4d2faeb4fb58c389dc9f76b8d5ae991ef4497e04"
, diffHash ? "sha256-DtMc8P4lTRzvS6PVvD7WtWEPsfnxIXSpqMsKKWs+edI="
, kernelPatches # must always be defined in bcachefs' all-packages.nix entry because it's also a top-level attribute supplied by callPackage
, argsOverride ? {}
, ...
} @ args:
# NOTE: bcachefs-tools should be updated simultaneously to preserve compatibility
(kernel.override ( args // {

  argsOverride = {
    version = "${kernel.version}-bcachefs-unstable-${commitDate}";
    modDirVersion = kernel.modDirVersion;

    extraMeta = {
      homepage = "https://bcachefs.org/";
      branch = "master";
      maintainers = with lib.maintainers; [ davidak Madouura raitobezarius YellowOnion ];
    };
  } // argsOverride;

  structuredExtraConfig = with lib.kernel; {
    BCACHEFS_FS = module;
    BCACHEFS_QUOTA = option yes;
    BCACHEFS_POSIX_ACL = option yes;
    # useful for bug reports
    FTRACE = option yes;
  };

  kernelPatches = [ {
      name = "bcachefs-${currentCommit}";

      patch = fetchpatch {
        name = "bcachefs-${currentCommit}.diff";
        url = "https://evilpiepirate.org/git/bcachefs.git/rawdiff/?id=${currentCommit}&id2=v${lib.versions.majorMinor kernel.version}";
        sha256 = diffHash;
      };
    } ] ++ kernelPatches;
}))
