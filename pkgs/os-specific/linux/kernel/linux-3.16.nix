{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.16.7";
  extraMeta.branch = "3.16";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0vm3ahw6wzq72z6jim05pcj9gzjw8jc4r1dr5wnfl810nib89pbk";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
