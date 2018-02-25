{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.118";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "14drszkabwin9fibs9gx67pf5l537ayyjappk70ynbrjxkxdq54q";
  };
} // (args.argsOverride or {}))
