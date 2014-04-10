{ stdenv, fetchurl, kernelPatches ? [], ... } @ args:

let
  patches = kernelPatches ++
   [{ name = "remove-driver-compilation-dates";
      patch = ./linux-3-10-35-no-dates.patch;
    }];
in

import ./generic.nix (args // rec {
  version = "3.10.53";
  extraMeta.branch = "3.10";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1sxa6ppgpy9fgj4lyj8d53y309v6r5nmifbrcf5pqs6l944frhq6";
  };

  kernelPatches = patches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
