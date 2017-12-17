{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.70";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "02ihsl286wq2fkbsiwmdk4na20nlrq628190libx583ghbrlbbxs";
  };
} // (args.argsOverride or {}))
