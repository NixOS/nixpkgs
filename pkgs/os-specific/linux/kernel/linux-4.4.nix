{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.106";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0h7b3mw20hlx2xxmh0xy7ffm9pdnb51qn56xrnds2mjpx47k147y";
  };
} // (args.argsOverride or {}))
