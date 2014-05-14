{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.12.19";
  extraMeta.branch = "3.12";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1f59lyyyc4anaj50dzb9448gz6n9fdrcy2mvd7f193pp6018gdp6";
  };

  kernelPatches = args.kernelPatches ++ [ { name = "cve-2014-0196"; patch = ./cve-2014-0196.patch; } ];

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
