{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.1.20";
  extraMeta.branch = "4.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1dpq8dgj351jzm7n6330a4xriz9dxv7d9wxzj9zn9q7ya22np9gs";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
