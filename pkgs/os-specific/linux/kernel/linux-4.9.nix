{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.67";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0zazyxn3q8bpinqvxjqkxg721vgzyk9agfbgr6hdyxvqq7fagfkz";
  };
} // (args.argsOverride or {}))
