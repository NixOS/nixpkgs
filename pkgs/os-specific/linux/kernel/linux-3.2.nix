{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.2.55";
  extraMeta.branch = "3.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "15fj7kd3ba52in1siqbdq45i7xzb53yy88l9k4bgfgds3j8wxj9m";
  };

  features.iwlwifi = true;
} // (args.argsOverride or {}))
