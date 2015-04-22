{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.18.12";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "06wfgg00vc5a2vvmg158ipbmigx803hdp3lhf4kv25p4sdmvbsl2";
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
