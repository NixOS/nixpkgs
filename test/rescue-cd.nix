let

  # The label used to identify the installation CD.
  cdromLabel = "NIXOS";

in

  # Build boot scripts for the CD that find the CD-ROM automatically.
  with import ./rescue-system.nix {
    autoDetectRootDevice = true;
    rootLabel = cdromLabel;
  };

  
rec {


  # Since the CD is read-only, the mount points must be on disk.
  cdMountPoints = pkgs.stdenv.mkDerivation {
    name = "mount-points";
    builder = builtins.toFile "builder.sh" "
      source $stdenv/setup
      mkdir $out
      cd $out
      mkdir proc sys tmp etc dev var mnt nix nix/var
      touch $out/${cdromLabel}
    ";
  };


  # Create an ISO image containing the isolinux boot loader, the
  # kernel, the initrd produced above, and the closure of the stage 2
  # init.
  rescueCD = import ./make-iso9660-image.nix {
    inherit (pkgs) stdenv cdrtools;
    isoName = "nixos.iso";
    
    contents = [
      { source = pkgs.syslinux + "/lib/syslinux/isolinux.bin";
        target = "isolinux/isolinux.bin";
      }
      { source = ./isolinux.cfg;
        target = "isolinux/isolinux.cfg";
      }
      { source = pkgs.kernel + "/vmlinuz";
        target = "isolinux/vmlinuz";
      }
      { source = initialRamdisk + "/initrd";
        target = "isolinux/initrd";
      }
      { source = cdMountPoints;
        target = "/";
      }
    ];

    init = bootStage2;
    
    bootable = true;
    bootImage = "isolinux/isolinux.bin";
  };


}
