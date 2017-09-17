{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.12.13";
  extraMeta.branch = "4.12";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "18sxw7mw4fya7381mkah70s3di6b8xxfigjhrhb7zcczrffb4vl9";
  };
} // (args.argsOverride or {}))
