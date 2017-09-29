{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.52";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "12h4w6x0zcl8kpia2y7myv7w7i0dihw4g8v638fs8bzk3d7h7pgz";
  };
} // (args.argsOverride or {}))
