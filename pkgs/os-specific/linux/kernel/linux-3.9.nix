{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.9.11";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0d5j7kg1ifzwipicbi4g26plzbzn1rlvgj1hs4zip6sxj8ifbffl";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
