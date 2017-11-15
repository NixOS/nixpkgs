{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.98";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1mvk6vw6fjqnl01bx78viydkalgj33v2ynz4gi4yk1d357l54yar";
  };
} // (args.argsOverride or {}))
