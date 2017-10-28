{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.111";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0260gvby59n550ijm9q43cnzw1gqizll28nv3vsv8qmgiqp2h0d2";
  };
} // (args.argsOverride or {}))
