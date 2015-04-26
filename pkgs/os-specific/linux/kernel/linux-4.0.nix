{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.0";
  modDirVersion = "4.0.0";
  extraMeta.branch = "4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "14argl6ywkggdvgiycfx4jl2d7290f631ly59wfggj4vjx27sbqg";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
