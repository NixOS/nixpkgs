{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13.5";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1qi5zxby5qwdv0485gia2jz38dly4ncn10zi3grcckwxc3d5ms59";
  };
} // (args.argsOverride or {}))
