{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.68";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0462cs1n04mw3df216q4qqxjgrhn76rdrnsdnf8myiccgmin0zyv";
  };
} // (args.argsOverride or {}))
