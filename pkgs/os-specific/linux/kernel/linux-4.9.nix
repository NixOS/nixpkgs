{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.10";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "098mcq3rg05gpammcdfhr2xhcy69ggc9h5g18m4ymnfqdx3havmx";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
