let

  # The label used to identify the installation CD.
  cdromLabel = "NIXOS";

in

  # Build boot scripts for the CD that find the CD-ROM automatically.
  with import ./boot-environment.nix {
    autoDetectRootDevice = true;
    rootLabel = cdromLabel;
    stage2Init = "/init";
    readOnlyRoot = true;
  };

  
rec {

  inherit nixosInstaller bootStage1 upstartJobs; # !!! debug


  # Since the CD is read-only, the mount points must be on disk.
  cdMountPoints = pkgs.stdenv.mkDerivation {
    name = "mount-points";
    builder = builtins.toFile "builder.sh" "
      source $stdenv/setup
      ensureDir $out
      cd $out
      mkdir proc sys tmp etc dev var mnt nix nix/var
      touch $out/${cdromLabel}
    ";
  };


  # We need a copy of the Nix expressions for Nixpkgs and NixOS on the
  # CD.  We put them in a tarball because accessing that many small
  # files from a slow device like a CD-ROM takes too long.
  makeTarball = tarName: input: pkgs.stdenv.mkDerivation {  
    name = "tarball";
    inherit tarName input;
    builder = builtins.toFile "builder.sh" "
      source $stdenv/setup
      ensureDir $out
      (cd $input && tar cvfj $out/$tarName . \\
        --exclude '*~' --exclude '.svn' \\
        --exclude 'pkgs' --exclude 'result')
    ";
  };

  
  # Put the current directory in the tarball.  !!! This gives us a lot
  # of crap (like .svn if this is a working copy).  An "svn export"
  # would be better, but that's impure.
  nixosTarball = makeTarball "nixos.tar.bz2" ./.;

  
  nixpkgsTarball = pkgs.fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nixpkgs-0.11pre7060/nixpkgs-0.11pre7060.tar.bz2;
    md5 = "67163e7a71f7b8cb01461e1d0467a6e1";
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
      { source = nixosTarball + "/" + nixosTarball.tarName;
        target = "/" + nixosTarball.tarName;
      }
      { source = nixpkgsTarball;
        target = "/nixpkgs.tar.bz2";
      }
    ];

    init = bootStage2;
    
    bootable = true;
    bootImage = "isolinux/isolinux.bin";
  };


}
