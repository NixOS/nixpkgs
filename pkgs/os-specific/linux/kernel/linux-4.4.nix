{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.103";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "017r4aq6bwhrir3n4nckd5407gpnryv0bbgpp7rv6lnzbxwd008x";
  };
} // (args.argsOverride or {}))
