{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.59";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "16rj4wg8psh3d47x8disk275nzzv26drvp03hi0r44mxw0lmd53k";
  };
} // (args.argsOverride or {}))
