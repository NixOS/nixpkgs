{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13.7";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "16vjjl3qw0a8ci6xbnywhb8bpr3ccbs0i6xa54lc094cd5gvx4v3";
  };
} // (args.argsOverride or {}))
