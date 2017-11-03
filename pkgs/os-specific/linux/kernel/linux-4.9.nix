{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.60";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "015dzkrhadmr3kadz0m3yhjikkmga8dv90f6s5ji5i2ja5f6qchf";
  };
} // (args.argsOverride or {}))
