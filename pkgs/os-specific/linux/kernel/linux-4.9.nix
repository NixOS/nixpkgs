{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.79";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0kf2zh7gf8jsm11vmp2hx2bji54ndsaj74ma405rj0qyxdchd45i";
  };
} // (args.argsOverride or {}))
