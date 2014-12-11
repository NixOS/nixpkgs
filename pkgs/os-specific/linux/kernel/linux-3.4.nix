{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.4.105";
  extraMeta.branch = "3.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0xhwdkpcmvbvk1rq0mz2f2pmh322flly7wr66wdd5bypfvanrk23";
  };

  kernelPatches = args.kernelPatches ++
    [ { name = "0001-UBUNTU-SAUCE-AppArmor-Add-profile-introspection-file";
        patch = ./apparmor-patches/3.4/0001-UBUNTU-SAUCE-AppArmor-Add-profile-introspection-file.patch;
      }
      { name = "0002-UBUNTU-SAUCE-AppArmor-basic-networking-rules";
        patch = ./apparmor-patches/3.4/0002-UBUNTU-SAUCE-AppArmor-basic-networking-rules.patch;
      }
      { name = "0003-UBUNTU-SAUCE-apparmor-Add-the-ability-to-mediate-mou";
        patch = ./apparmor-patches/3.4/0003-UBUNTU-SAUCE-apparmor-Add-the-ability-to-mediate-mou.patch;
      }];

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
})
