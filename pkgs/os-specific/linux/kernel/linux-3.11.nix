{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.11.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1kv6j7mc5r5qw43kirc0fv83khpnwy8m7158qf8ar08p3r01i3mi";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
