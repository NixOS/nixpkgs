{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13.6";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0l30vlxmp49mm743cydkvr3wfw4nmh0q71avasnksd8xmv71km27";
  };
} // (args.argsOverride or {}))
