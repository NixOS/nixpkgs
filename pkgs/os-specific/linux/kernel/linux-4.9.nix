{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.64";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1h1h71nyiwvx2jy3j3yjazya6gz3k47bhm00mm311syaplhp0qhr";
  };
} // (args.argsOverride or {}))
