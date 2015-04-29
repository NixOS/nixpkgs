{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.0.1";
  extraMeta.branch = "4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1ggj26p1bm5v5kaviz6brfkjk32f8rib1mh61ns77gjlx5vsvc7z";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
