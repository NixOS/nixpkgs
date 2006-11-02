rec {

  pkgs = import ./pkgs/top-level/all-packages.nix {};

  stdenvLinuxStuff = import ./pkgs/stdenv/linux {
    system = pkgs.stdenv.system;
    allPackages = import ./pkgs/top-level/all-packages.nix;
  };

  bash = pkgs.bash;

  
  initialRamdisk = import ./make-initrd.nix {
    inherit (pkgs) stdenv cpio;
    packages = [
      stdenvLinuxStuff.staticTools
    ];
    init = stdenvLinuxStuff.bootstrapTools.bash;
  };

  
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
          #/boot/initrd-2.6.13-15.12-default;
        target = "isolinux/initrd";
      }
    ];
    
    bootable = true;
    bootImage = "isolinux/isolinux.bin";
  };

    
}
