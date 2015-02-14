{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.10.69";
  extraMeta.branch = "3.10";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "14m4npds1f0whsd1nhnpl3bsscck9kg0r8bvrha4bdlhc8fjzrrc";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
