{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.13.6";
  extraMeta.branch = "3.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "10j1rc63y0rcrnc2rx8jyczqg42gcbijd83qqd795qrrp5wnf7qw";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
