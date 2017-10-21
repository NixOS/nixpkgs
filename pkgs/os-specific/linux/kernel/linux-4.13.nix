{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13.9";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "13ra6psp6w3rf5vzmvhg88v2nh8zq20xl0r92728b8x9vgj1bp51";
  };
} // (args.argsOverride or {}))
