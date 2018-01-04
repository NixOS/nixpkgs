{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.74";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1ivhzmsa8n5ns8igryzb9dyaakq2p51j23f6j9kpqyby7842i1y8";
  };
} // (args.argsOverride or {}))
