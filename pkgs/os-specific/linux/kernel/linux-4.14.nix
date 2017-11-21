{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.14.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1rsdrdapjw8lhm8dyckwxfihykirbkincm5k0lwwx1pr09qgdfbg";
  };
} // (args.argsOverride or {}))
