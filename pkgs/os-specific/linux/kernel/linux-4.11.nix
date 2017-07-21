{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.11.11";
  extraMeta.branch = "4.11";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1dvs1r3vq15akyv0yxvim6j09pqac5dagqbchvdlsw5yi4fnylc8";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
