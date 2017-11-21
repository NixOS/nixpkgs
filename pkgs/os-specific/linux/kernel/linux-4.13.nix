{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13.15";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1cnixf90pi9xsb8p1sncwcnl5acp8b46xxxmsizk335knmn919g4";
  };
} // (args.argsOverride or {}))
