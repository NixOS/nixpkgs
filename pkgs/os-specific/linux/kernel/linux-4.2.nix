{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.2.6";
  extraMeta.branch = "4.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0p7v6v3v9kn7w5iragi5hx0dylhis0jy6xmk77gka486q1ynpnqp";
  };

  kernelPatches = args.kernelPatches ++ [ { name = "cve-2016-0728"; patch = ./cve-2016-0728.patch; } ];

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
