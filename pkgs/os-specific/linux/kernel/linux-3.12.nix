{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.12.20";
  extraMeta.branch = "3.12";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "15pjvlqbbyif8s8mcpb7wf20fvbczhfp65mn6fd609j1p79nvqb9";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
