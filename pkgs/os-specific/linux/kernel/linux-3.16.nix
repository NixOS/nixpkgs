{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.16.2";
  extraMeta.branch = "3.16";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "16l5l099qv367d3gknpbycgrakli2mdklvgaifsn3hcrrjs44ybf";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
