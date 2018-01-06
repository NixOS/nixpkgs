{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.75";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1pyan45647wnliwhhp3dlmyvz7ibl1i56qplf3ilfh4dcsvk2v6y";
  };
} // (args.argsOverride or {}))
