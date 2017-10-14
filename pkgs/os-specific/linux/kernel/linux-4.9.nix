{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.56";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1jnkf0ir42xkandx1lnqrxmskzwl6j46aqmzrxilddx9pkdjplhi";
  };
} // (args.argsOverride or {}))
