{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.50";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0dhm5w7qa1hyqp254r41b4nhf10a8w7sv1mhd16f61inpb41829c";
  };
} // (args.argsOverride or {}))
