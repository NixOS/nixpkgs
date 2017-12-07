{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.65";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "15a8a7p6i2dgiglps22cwsy5gsfkc39fy4jzvhjwz8s9fn3p1fi4";
  };
} // (args.argsOverride or {}))
