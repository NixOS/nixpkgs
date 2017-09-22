{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13.3";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1ayai3i0jakxzszpijhknjiwwi055wa74bpmnr0n7dh2l5s2rlh3";
  };
} // (args.argsOverride or {}))
