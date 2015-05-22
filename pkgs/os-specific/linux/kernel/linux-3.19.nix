{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.19.8";
  extraMeta.branch = "3.19";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0yg2mlq0h9my6k1bg3b255w4qnyx609ngh1nhssx3gbzslwf0jyg";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
