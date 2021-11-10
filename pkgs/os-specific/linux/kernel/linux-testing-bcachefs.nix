{ lib
, fetchpatch
, kernel
, date ? "2021-11-06"
, commit ? "10669a2c540de3276c8d2fc0e43be62f2886f377"
, diffHash ? "1rn72wd8jg919j74x8banl70b2bdd6r9fgvnw693j20dq96j5cnw"
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
      maintainers = with lib.maintainers; [ davidak chiiruno ];
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
