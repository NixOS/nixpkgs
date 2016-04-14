{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.14.63";
  extraMeta.branch = "3.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0q3qcgcaxjc298dgjpfn6g17lvki2p87f0zkaxs0h0g13jhykwbz";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
