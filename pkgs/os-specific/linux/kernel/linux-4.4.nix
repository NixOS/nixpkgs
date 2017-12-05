{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.97";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "03hnm66nv7l1f21z893rghgpgghs1i2pxzhcahpi7d6nsm5mwqgq";
  };
} // (args.argsOverride or {}))
