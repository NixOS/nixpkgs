{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.4.61";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1izjmpcb2ww1pj5nyxgnx4v5ghl0d173w2s6py89ai4yqzqamhnf";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
})
