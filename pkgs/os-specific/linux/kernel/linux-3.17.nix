{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.17.2";
  extraMeta.branch = "3.17";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "15m7mrl4vrwddh7ivjarjfivmjr63zmbb2vvnn532mc9hz01s8pr";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
