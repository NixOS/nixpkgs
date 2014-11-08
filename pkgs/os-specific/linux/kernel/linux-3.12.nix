{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.12.32";
  extraMeta.branch = "3.12";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1hzws2bf267hfk81ywqcxspkyi1lg56x63izdc0pv1338xcfas53";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
