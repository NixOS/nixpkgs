{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.11";
  modDirVersion = "3.11.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1yfpa4fzhsn4r5dwkcf3azy0vqdms865jaikn3fdwbabmpqchgl0";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
