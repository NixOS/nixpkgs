{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.107";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "05qsi0rhbacx317vq5ls0h2zhi6kiik073z6xlc4blq5icyc4pfj";
  };
} // (args.argsOverride or {}))
