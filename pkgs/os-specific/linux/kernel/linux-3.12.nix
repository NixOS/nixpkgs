{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.12-rc3";

  src = fetchurl {
    url = "https://www.kernel.org/pub/linux/kernel/v3.0/testing/linux-${version}.tar.gz";
    sha256 = "1rayb0f4n81yp9ghcws0v36dpqyl9ks3naf37p2qy7jvrwagmj28";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
