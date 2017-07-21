{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.12.2";
  extraMeta.branch = "4.12";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1ql5y6bvb1bx9b2k5iksdzjgzxnq852rvq69kdnkwa98p8p8ayha";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
