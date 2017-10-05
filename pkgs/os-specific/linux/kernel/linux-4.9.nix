{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.53";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "095k7kpzic0c2vhwnfm5vcp9j60lyf4qyx2pj9vkp68bpcrmm49j";
  };
} // (args.argsOverride or {}))
