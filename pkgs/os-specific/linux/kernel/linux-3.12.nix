{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.12";

  modDirVersion = "3.12.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "00jshh7abn8fj6zsbmfaxxfpg83033413k5nqqfsb7z1zp3hw4if";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
