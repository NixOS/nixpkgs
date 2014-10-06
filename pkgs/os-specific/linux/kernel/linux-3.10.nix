{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.10.56";
  extraMeta.branch = "3.10";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "02q0rda1dsapfi2d3nz398fhlk0gvr2q6mj6jcck2izcxzqhsz9a";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
