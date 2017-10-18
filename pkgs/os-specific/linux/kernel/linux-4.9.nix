{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.57";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "19lndirbyryx0qdwqqhn1g4rng7d79rk4sra5lpa2d3axia0a8q9";
  };
} // (args.argsOverride or {}))
