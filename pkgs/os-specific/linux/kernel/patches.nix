{ stdenv, fetchurl }:

let
  patches = rec {
    btrfs_fix_deadlock =
      { name  = "btrfs-fix-deadlock";
        patch = ./patches/btrfs-fix-deadlock.patch;
      };

    bridge_stp_helper =
      { name = "bridge-stp-helper";
        patch = ./patches/bridge-stp-helper.patch;
      };
  };
in patches
