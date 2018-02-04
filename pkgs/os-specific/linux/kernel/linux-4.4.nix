{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.115";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1pxm4r09402h4k8zgl0w1wm4vfvcaa3y7l36h50jr5wgi6l8rx2q";
  };
} // (args.argsOverride or {}))
