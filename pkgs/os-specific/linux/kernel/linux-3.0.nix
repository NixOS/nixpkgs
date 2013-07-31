{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.0.88";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1icfkbn9a5cpwiax1xklvpqyjcvqij3dwib009fipp53z4pn5bz4";
  };

  features.iwlwifi = true;
})
