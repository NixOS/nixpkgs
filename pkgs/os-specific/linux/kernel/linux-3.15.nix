{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.15.2";
  extraMeta.branch = "3.15";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "09nq8q84xn6lwzdnn36pzfiqhn1lapi60yxn4hifb7v9ymhc5sv6";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
