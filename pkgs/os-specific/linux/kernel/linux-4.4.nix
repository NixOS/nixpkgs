{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.112";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1k8ys7zxdbz9vkhhrb6p85dpsl5ljzy1hsn72mhqj8nhxv5l4jsl";
  };
} // (args.argsOverride or {}))
