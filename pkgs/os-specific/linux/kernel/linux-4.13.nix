{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13.12";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0x6yz5yb25789ky6hm55abja9374gcaqz06hg7rmmap3y1dhd65z";
  };
} // (args.argsOverride or {}))
