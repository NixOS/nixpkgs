{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.114";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1nag129dv3krn9b3f958fv2ns56x1nlgf8fy3mx74pkzqm6hnh4m";
  };
} // (args.argsOverride or {}))
