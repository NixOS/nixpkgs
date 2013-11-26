{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.4.70";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0l0ln1jmrknvg9ibv13s8b9rzn3ck789y13hpdv04as5wp738v20";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
})
