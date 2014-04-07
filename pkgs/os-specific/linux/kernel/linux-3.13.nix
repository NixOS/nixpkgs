{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.13.8";
  extraMeta.branch = "3.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0z6lfsf1ldv7id3fm6l5jdn7c6076605wj7mfi90pgf079kbbqwj";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
