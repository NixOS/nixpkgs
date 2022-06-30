{ lib
, fetchpatch
, kernel
, date ? "2022-04-25"
, commit ? "bdf6d7c1350497bc7b0be6027a51d9330645672d"
, diffHash ? "09bcbklvfj9i9czjdpix2iz7fvjksmavaljx8l92ay1i9fapjmhc"
, kernelPatches # must always be defined in bcachefs' all-packages.nix entry because it's also a top-level attribute supplied by callPackage
, argsOverride ? {}
, ...
} @ args:

# NOTE: bcachefs-tools should be updated simultaneously to preserve compatibility
(kernel.override ( args // {
  argsOverride = {
    version = "${kernel.version}-bcachefs-unstable-${date}";

    extraMeta = {
      branch = "master";
      maintainers = with lib.maintainers; [ davidak Madouura ];
      broken = true;
    };
  } // argsOverride;

  kernelPatches = [ {
      name = "bcachefs-${commit}";

      patch = fetchpatch {
        name = "bcachefs-${commit}.diff";
        url = "https://evilpiepirate.org/git/bcachefs.git/rawdiff/?id=${commit}&id2=v${lib.versions.majorMinor kernel.version}";
        sha256 = diffHash;
      };

      extraConfig = "BCACHEFS_FS m";
    } ] ++ kernelPatches;
}))
