{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.16.4";
  extraMeta.branch = "3.16";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0x8jh9j7kdfbxcf3f69p28j5dwjjdxf92sjnlhk3mp016yv02i99";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
