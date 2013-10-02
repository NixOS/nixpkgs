{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.11.3";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "15jk6ak00dmsjqi6snsp6843f2pij6rwrhlg1p14shab3xjp1wxl";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
