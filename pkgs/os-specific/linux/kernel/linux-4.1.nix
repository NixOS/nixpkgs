{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.1.15";
  extraMeta.branch = "4.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "18sr0dl5ax6pcx6nqp9drb4l6a38g07vxihiqpbwb231jv68h8j7";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
