{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.95";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "07vkxhh435gilxsh9ag6zvf2r9k5l9ffqp72900c50nsfjrdgdrx";
  };
} // (args.argsOverride or {}))
