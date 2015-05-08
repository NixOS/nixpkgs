{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.18.13";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "043bqjvbamzi201csgnw7hsf8810qm0dn7x9p0kc7s9p9jnyq79n";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
