{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.72";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0fxqfqcqn6rk6rxzmy8r3vgzvy9xlnb3hvg2rniykbcyxgqh3wk9";
  };
} // (args.argsOverride or {}))
