{ lib
, fetchpatch
, kernel
, date ? "2021-09-22"
, commit ? "bd6ed9fb42c0aa36d1f4a21eeab45fe12e1fb792"
, diffHash ? "0wml259g1z990kg3bdl1rpmlvcazdpv1fc8vm3kjxpncdp7637wp"
, kernelPatches # must always be defined in bcachefs' all-packages.nix entry because it's also a top-level attribute supplied by callPackage
, argsOverride ? {}
, ...
} @ args:

kernel.override ( args // {

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

})
