rec {

  pkgs = import ./pkgs/top-level/all-packages.nix {};

  pkgsDiet = import ./pkgs/top-level/all-packages.nix {
    bootStdenv = pkgs.useDietLibC pkgs.stdenv;
  };

  pkgsStatic = import ./pkgs/top-level/all-packages.nix {
    bootStdenv = pkgs.makeStaticBinaries pkgs.stdenv;
  };

  stdenvLinuxStuff = import ./pkgs/stdenv/linux {
    system = pkgs.stdenv.system;
    allPackages = import ./pkgs/top-level/all-packages.nix;
  };


  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = import ./modules-closure.nix {
    inherit (pkgs) stdenv kernel module_init_tools;
    rootModules = ["ide-cd" "ide-disk" "ide-generic"];
  };


  # Some additional utilities needed in stage 1, notably mount.  We
  # don't want to bring in all of util-linux, so we just copy what we
  # need.
  extraUtils = pkgs.stdenv.mkDerivation {
    name = "extra-utils";
    builder = builtins.toFile "builder.sh"
      "source $stdenv/setup; ensureDir $out/bin; cp $utillinux/bin/mount $out/bin; nuke-refs $out/bin/mount";
    buildInputs = [pkgs.nukeReferences];
    inherit (pkgsStatic) utillinux;
  };
  

  # The init script of boot stage 1 (loading kernel modules for
  # mounting the root FS).
  bootStage1 = import ./boot-stage-1.nix {
    inherit (pkgs) genericSubstituter;
    inherit (pkgsDiet) module_init_tools;
    inherit extraUtils;
    modules = modulesClosure;
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

    init = pkgs.bash + "/bin/sh";
    
    bootable = true;
    bootImage = "isolinux/isolinux.bin";
  };

    
}
