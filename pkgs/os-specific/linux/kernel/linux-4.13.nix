{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13.4";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "087lv2laf4wx28z9zqg9s275nzygica0hc1g8vn5ql6yb7mrb7m0";
  };
} // (args.argsOverride or {}))
