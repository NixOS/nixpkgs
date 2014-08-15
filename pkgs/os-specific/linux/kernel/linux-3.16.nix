{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.16.1";
  extraMeta.branch = "3.16";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0wbxqlmk7w9047ir51dsz6vi7ww0hpycgrb43mk2a189xaldsdxy";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
