{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.11.10";
  extraMeta.branch = "3.11";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "00g4rbkjsmyzzm9zmdll8qqs1mffa0pybwjpn9jnli2kgh9inzyb";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
