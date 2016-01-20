{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.14.58";
  # Remember to update grsecurity!
  extraMeta.branch = "3.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0jw1023cpn4bjmi0db86lrxri9xj75cj8p2iqs44jabvh35idl7l";
  };

  kernelPatches = args.kernelPatches ++ [ { name = "cve-2016-0728"; patch = ./cve-2016-0728.patch; } ];

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
