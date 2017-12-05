{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13.16";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0cf7prqzl1ajbgl98w0symdyn0k5wl5xaf1l5ldgy6l083yg69dh";
  };
} // (args.argsOverride or {}))
