{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.99";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0mkyipq1l0lh04shavanx61z75c5r66xh33x47pswvhr2j6mjqxf";
  };
} // (args.argsOverride or {}))
