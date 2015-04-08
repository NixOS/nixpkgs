{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.18.10";
  # Remember to update grsecurity!
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0kmh0ybjh1l35pm421v2q3z9fyhss85agh1rkmnh9bim2bq1ac6h";
  };

  # FIXME: remove with the next point release.
  kernelPatches = args.kernelPatches ++
    [ { name = "btrfs-fix-deadlock";
        patch = ./btrfs-fix-deadlock.patch;
      }
    ];

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
