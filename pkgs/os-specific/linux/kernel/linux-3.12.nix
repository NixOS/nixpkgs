{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.12-rc2";

  src = fetchurl {
    url = "https://www.kernel.org/pub/linux/kernel/v3.0/testing/linux-${version}.tar.gz";
    sha256 = "1m24fh3cwmkb1scn3sl7gbc50jl53v357kjpgda9avi3ljxmyq5z";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
