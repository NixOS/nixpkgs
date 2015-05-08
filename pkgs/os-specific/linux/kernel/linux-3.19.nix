{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.19.7";
  extraMeta.branch = "3.19";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0xd38f7g5yfn0b6b2l4qr022f9hcr82ddbysjs4npbgk5ms7341k";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
