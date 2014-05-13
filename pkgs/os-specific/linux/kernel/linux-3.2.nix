{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.2.58";
  extraMeta.branch = "3.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1mszzixiv4k61m241dl2n5s8rca26l6hc40v23lha814nrahjkn1";
  };

  features.iwlwifi = true;
} // (args.argsOverride or {}))
