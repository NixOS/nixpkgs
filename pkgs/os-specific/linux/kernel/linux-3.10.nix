{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.10.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1kwi5v4rw06rmb548wjkgi27amsfvpfd2n07bmyjvjqnqrldm5bk";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
