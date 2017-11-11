{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.61";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "17ni4skllgd24ddg1ifj1s9b5mqx38filrabgmlw7w4ff9src8z0";
  };
} // (args.argsOverride or {}))
