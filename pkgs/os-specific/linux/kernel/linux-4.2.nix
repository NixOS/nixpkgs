{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.2.1";
  extraMeta.branch = "4.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1b4dpf3rhr1sb1hpz4qx3h1swlcr1xnbrh6sjybqmj2c6szkbpvz";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # cherry-pick from upstream to resolve a licensing problem that prevents
  # compiling the broadcom-sta wireless driver on kernels >= 4.2
  # see: https://github.com/longsleep/bcmwl-ubuntu/issues/6
  kernelPatches = [ {
    name = "flush-workqueue-export";
    patch = ./flush_workqueue-export.patch;
  } ];
} // (args.argsOverride or {}))
