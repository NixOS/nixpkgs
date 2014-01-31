{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.4.78";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1n9avgjy3qpr28n1rq80kc1gn33w9nz6bvwds6i4d5z793fp7qpk";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
})
