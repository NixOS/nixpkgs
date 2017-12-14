{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.69";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0x29la3mipvqcqpb945wrzvwh2s4y5a1gz67ygx4v9vmzbgb6q2q";
  };
} // (args.argsOverride or {}))
