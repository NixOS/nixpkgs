{ lib
, fetchpatch
, kernel
, date ? "2022-03-09"
, commit ? "2280551cebc1735f74eef75d650dd5e175461657"
, diffHash ? "1mrrydidbapdq0fs0vpqhs88k6ghdrvmjpk2zi7xlwj7j32h0nwp"
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
