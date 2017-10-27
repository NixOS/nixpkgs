{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13.10";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0c33v0y4hyklhz7i00sjrj2cpn6zlwc7qjj7w2zzxmnr9yn90c6x";
  };
} // (args.argsOverride or {}))
