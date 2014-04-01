{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.4.85";
  extraMeta.branch = "3.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1ldbq9qka6bdgic4ydl9pnny734gyi2vxzdsnfmfi8mx7bnar29y";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
})
