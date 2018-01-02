{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.108";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "06m5bcvz1s6c28j5629mxzhmka5f6gh46jqyxyqggsawcac1202s";
  };
} // (args.argsOverride or {}))
