{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.12.50";
  extraMeta.branch = "3.12";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1bn07wsrcbg4qgqd4v2810c3qc0ifbcza0fyj8s54yd78g9qj4lj";
  };

  kernelPatches = args.kernelPatches ++ [ { name = "cve-2016-0728"; patch = ./cve-2016-0728.patch; } ];

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
