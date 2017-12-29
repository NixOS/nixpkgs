{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.102";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1zmaispqs9lw1kyalhln2l53hsg99riisgnmc50qj7cyalmc5qpd";
  };
} // (args.argsOverride or {}))
