{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.4.66";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "09jrj989mqk76klrg5zq1z8qrx3gif69bqi78ywq3jky8dmrwz3y";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
})
