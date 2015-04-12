{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.0";
  modDirVersion = "4.0.0";
  extraMeta.branch = "4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0nis1r9fg562ysirzlyvfxvirpcfhxhhpfv3s13ccz20qiqiy46f";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
