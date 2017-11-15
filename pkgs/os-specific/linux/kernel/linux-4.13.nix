{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13.13";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0izyma1b9bh4hfp00ph91n91zqkbwjnkdifvr4h8ipmxm0y8ig0m";
  };
} // (args.argsOverride or {}))
