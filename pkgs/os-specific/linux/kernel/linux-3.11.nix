{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.11.6";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0klbyx6qy3ifwrwh5w7yzk6m6jd32flkk73z95bih3ihmbnbzlvs";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
