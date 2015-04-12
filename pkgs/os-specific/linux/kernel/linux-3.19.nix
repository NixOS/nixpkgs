{ stdenv, fetchurl, ... } @ args:

let
  patches = (import ./patches { inherit stdenv fetchurl; });
in
import ./generic.nix (args // rec {
  version = "3.19.3";        # Remember to update grsecurity!
  extraMeta.branch = "3.19";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0nis1r9fg562ysirzlyvfxvirpcfhxhhpfv3s13ccz20qiqiy46f";
  };

  # FIXME: remove with the next point release.
  kernelPatches = args.kernelPatches ++
    [ patches.btrfs_fix_deadlock
    ];

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
