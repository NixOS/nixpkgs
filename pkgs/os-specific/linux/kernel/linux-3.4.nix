{ stdenv, fetchurl, apparmor-kernel-patches, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.4.106";
  extraMeta.branch = "3.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1l1k2kmlz0j12ly63w3mhvdzp5fpc22ajda4kw66fyjx96npm8sc";
  };

  kernelPatches = args.kernelPatches ++
    [ rec { name  = "0001-UBUNTU-SAUCE-AppArmor-Add-profile-introspection-file";
            patch = "${apparmor-kernel-patches}/${extraMeta.branch}/${name}.patch";
          }
      rec { name  = "0002-UBUNTU-SAUCE-AppArmor-basic-networking-rules";
            patch = "${apparmor-kernel-patches}/${extraMeta.branch}/${name}.patch";
          }
      rec { name  = "0003-UBUNTU-SAUCE-apparmor-Add-the-ability-to-mediate-mou";
            patch = "${apparmor-kernel-patches}/${extraMeta.branch}/${name}.patch";
          }
    ];

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
})
