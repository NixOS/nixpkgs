{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.12.15";
  extraMeta.branch = "3.12";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "08y42y5piibql0v6pwdp19nxvw5jngs4nw404lwh412zk0cnh4gn";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
