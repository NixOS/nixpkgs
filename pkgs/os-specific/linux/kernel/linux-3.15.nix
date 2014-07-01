{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.15.3";
  extraMeta.branch = "3.15";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0i8dmx1yiaraxb7gsjm7wpy0rv8038nbrwl2slzq749pgm4bd5bf";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
