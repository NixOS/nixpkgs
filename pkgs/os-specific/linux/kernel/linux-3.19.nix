{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.19.1";
  # Remember to update grsecurity!
  extraMeta.branch = "3.19";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0qx7vxmlcwr4nvzf4wq0da7xwzqw4b67h9a5rfpxgg9mayk3czvi";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
