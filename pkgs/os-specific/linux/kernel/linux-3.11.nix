{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.11.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "16wblz06129lxvxsl3rhmdj4b31yzmwv3rxnjmrlj3c3qlzph29c";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
