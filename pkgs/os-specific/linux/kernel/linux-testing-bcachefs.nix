{ lib
, stdenv
, fetchpatch
, kernel
# bcachefs-tools stores the expected-revision in:
#   https://evilpiepirate.org/git/bcachefs-tools.git/tree/.bcachefs_revision
# but this does not means that it'll be the latest-compatible revision
, version ? lib.importJSON ./bcachefs.json
, kernelPatches # must always be defined in bcachefs' all-packages.nix entry because it's also a top-level attribute supplied by callPackage
, argsOverride ? {}
, ...
} @ args:

# NOTE: bcachefs-tools should be updated simultaneously to preserve compatibility
(kernel.override ( args // {
  version = "${kernel.version}-bcachefs-unstable-${version.date}";

  extraMeta = {
    branch = "master";
    broken = stdenv.isAarch64;
    maintainers = with lib.maintainers; [ davidak Madouura pedrohlc raitobezarius YellowOnion ];
  };

  structuredExtraConfig = with lib.kernel; {
    BCACHEFS_FS = module;
    BCACHEFS_QUOTA = option yes;
    BCACHEFS_POSIX_ACL = option yes;
    # useful for bug reports
    FTRACE = option yes;
  };

  kernelPatches = [ {
      name = "bcachefs-${version.commit}";

      patch = fetchpatch {
        name = "bcachefs-${version.commit}.diff";
        url = "https://evilpiepirate.org/git/bcachefs.git/rawdiff/?id=${version.commit}&id2=v${lib.versions.majorMinor kernel.version}";
        sha256 = version.diffHash;
      };
    } ] ++ kernelPatches;
}))
