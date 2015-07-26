{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.18.19";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1jdp4mixggzjy1v806v5q7qqimkm6pbjav3gwbcl2cccv6wd701x";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
