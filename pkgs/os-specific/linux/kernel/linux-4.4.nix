{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.96";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1asvcqip5w9nkg4c5jllbjygski9cnw7qn6ci7p6zwnd2mfks794";
  };
} // (args.argsOverride or {}))
