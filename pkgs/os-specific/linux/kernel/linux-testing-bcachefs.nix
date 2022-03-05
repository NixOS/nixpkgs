{ lib
, fetchpatch
, kernel
, date ? "2022-01-12"
, commit ? "0e6eb60f8be14b02e0a76cb330f4b22c80ec82e9"
, diffHash ? "091w4r7h93s5rv8hk65aix7l0rr4bd504mv998j7x360bqlb7vpi"
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
