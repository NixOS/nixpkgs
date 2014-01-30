{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.13";

  modDirVersion = "3.13.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "4d5e5eee5f276424c32e9591f1b6c971baedc7b49f28ce03d1f48b1e5d6226a2";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
