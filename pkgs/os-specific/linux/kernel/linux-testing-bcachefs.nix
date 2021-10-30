{ lib
, fetchpatch
, kernel
, date ? "2021-07-08"
, commit ? "3693b2ca83ff9eda49660b31299d2bebe3a1075f"
, diffHash ? "1sfq3vwc2kxa761s292f2cqrm0vvqvkdx6drpyn5yaxwnapwidcw"
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
      platforms = [ "x86_64-linux" ];
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

})).overrideAttrs ({ meta ? {}, ... }: { meta = meta // { broken = true; }; })
