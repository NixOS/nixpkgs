{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.13.4";
  extraMeta.branch = "3.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0hzxr8gsafnyc96x5p2clgi827ahidk1hma0yd48gdx9dhynrq2r";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
