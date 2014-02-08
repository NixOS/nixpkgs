{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.2.54";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "15mr1mrsldvs3jx9nc25pfmmdbz2ykiaxnqc26chn6k425l4kn67";
  };

  features.iwlwifi = true;
} // (args.argsOverride or {}))
