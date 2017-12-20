{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.71";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "173nvdshckhdlisn08pf6cal9bhlj8ra569y26013hsfzd09gzgi";
  };
} // (args.argsOverride or {}))
