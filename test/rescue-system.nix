rec {

  pkgs = import ./pkgs/top-level/all-packages.nix {};

  pkgsDiet = import ./pkgs/top-level/all-packages.nix {
    bootStdenv = pkgs.useDietLibC pkgs.stdenv;
  };

  stdenvLinuxStuff = import ./pkgs/stdenv/linux {
    system = pkgs.stdenv.system;
    allPackages = import ./pkgs/top-level/all-packages.nix;
  };

  bash = pkgs.bash;


  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = import ./modules-closure.nix {
    inherit (pkgs) stdenv kernel;
    rootModules = "ide-cd";
  };


  # The init script of boot stage 1 (loading kernel modules for
  # mounting the root FS).
  bootStage1 = import ./boot-stage-1.nix {
    inherit (pkgs) genericSubstituter
      module_init_tools utillinux kernel;
    shell = stdenvLinuxStuff.bootstrapTools.bash;
    staticTools = stdenvLinuxStuff.staticTools;
  };
  

  # The closure of the init script of boot stage 1 is what we put in
  # the initial RAM disk.
  initialRamdisk = import ./make-initrd.nix {
    inherit (pkgs) stdenv cpio;
    packages = [];
    init = bootStage1;
  };


  # Create an ISO image containing the isolinux boot loader, the
  # kernel, and initrd produced above.
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
    ];
    
    bootable = true;
    bootImage = "isolinux/isolinux.bin";
  };

    
}
