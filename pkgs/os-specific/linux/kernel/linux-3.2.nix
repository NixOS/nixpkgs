{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.2.59";
  extraMeta.branch = "3.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0a62nmn90k3g48m8g3y27q6a0qwa3k2s6synss7378kdi4f938i4";
  };

  features.iwlwifi = true;
} // (args.argsOverride or {}))
