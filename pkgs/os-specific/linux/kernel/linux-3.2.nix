{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.2.64";
  extraMeta.branch = "3.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0niw4pbfc5dd46wzgvfnza8isyl01v1lva4njlwnrzag6x9fj0qp";
  };

  # We don't provide these patches if grsecurity is enabled, because
  # the grsec 3.2 -stable patchset already includes them.
  kernelPatches = args.kernelPatches ++ (
    stdenv.lib.optionals (!(args.features.grsecurity or false))
      [ { name = "0001-AppArmor-compatibility-patch-for-v5-network-controll";
          patch = ./apparmor-patches/3.2/0001-AppArmor-compatibility-patch-for-v5-network-controll.patch;
        }
        { name = "0002-AppArmor-compatibility-patch-for-v5-interface";
          patch = ./apparmor-patches/3.2/0002-AppArmor-compatibility-patch-for-v5-interface.patch;
        }
        { name = "0003-AppArmor-Allow-dfa-backward-compatibility-with-broke";
          patch = ./apparmor-patches/3.2/0003-AppArmor-Allow-dfa-backward-compatibility-with-broke.patch;
        }]);

  features.iwlwifi  = true;
} // (args.argsOverride or {}))
