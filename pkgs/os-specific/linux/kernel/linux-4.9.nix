{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.62";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0cpxhj40dxm0i9yg4hg5hwlhq4083l7i5jc3psfr6zcy5k7c5ph2";
  };
} // (args.argsOverride or {}))
