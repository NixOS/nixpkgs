{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.55";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0a9rjlf7h1rn71kll1ckxa440rxwsikh1yjh37zbsj5i4895gz5i";
  };
} // (args.argsOverride or {}))
