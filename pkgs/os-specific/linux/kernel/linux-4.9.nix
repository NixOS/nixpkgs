{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.63";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "18rfvzsxgjr9223r3lznbrj6fh533d68nizpcz556d7x6dpkij91";
  };
} // (args.argsOverride or {}))
