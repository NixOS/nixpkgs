{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13.11";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1vzl2i72c8iidhdc8a490npsbk7q7iphjqil4i9609disqw75gx4";
  };
} // (args.argsOverride or {}))
