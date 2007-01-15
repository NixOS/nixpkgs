{ platform ? __currentSystem
, stage2Init ? ""
, configuration
}:

rec {

  # Make a configuration object from which we can retrieve option
  # values.
  config = import ./config.nix pkgs configuration;
  

  pkgs = import ../pkgs/top-level/all-packages.nix {system = platform;};

  pkgsDiet = import ../pkgs/top-level/all-packages.nix {
    system = platform;
    bootStdenv = pkgs.useDietLibC pkgs.stdenv;
  };

  pkgsStatic = import ../pkgs/top-level/all-packages.nix {
    system = platform;
    bootStdenv = pkgs.makeStaticBinaries pkgs.stdenv;
  };

  stdenvLinuxStuff = import ../pkgs/stdenv/linux {
    system = pkgs.stdenv.system;
    allPackages = import ../pkgs/top-level/all-packages.nix;
  };

  nix = pkgs.nixUnstable; # we need the exportReferencesGraph feature


  rootModules = 
    (config.get ["boot" "initrd" "extraKernelModules"]) ++
    (config.get ["boot" "initrd" "kernelModules"]);


  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = import ../helpers/modules-closure.nix {
    inherit (pkgs) stdenv kernel module_init_tools;
    inherit rootModules;
  };


  # Some additional utilities needed in stage 1, notably mount.  We
  # don't want to bring in all of util-linux, so we just copy what we
  # need.
  extraUtils = pkgs.runCommand "extra-utils"
    { buildInputs = [pkgs.nukeReferences];
      inherit (pkgsStatic) utillinux;
      inherit (pkgsDiet) udev;
      inherit (pkgs) splashutils;
      e2fsprogs = pkgs.e2fsprogsDiet;
      allowedReferences = []; # prevent accidents like glibc being included in the initrd
    }
    "
      ensureDir $out/bin
      cp $utillinux/bin/mount $utillinux/bin/umount $utillinux/sbin/pivot_root $out/bin
      cp -p $e2fsprogs/sbin/fsck* $e2fsprogs/sbin/e2fsck $out/bin
      cp $splashutils/bin/splash_helper $out/bin
      cp $udev/sbin/udevd $udev/sbin/udevtrigger $udev/sbin/udevsettle $out/bin
      nuke-refs $out/bin/*
    ";
  

  # The init script of boot stage 1 (loading kernel modules for
  # mounting the root FS).
  bootStage1 = import ../boot/boot-stage-1.nix {
    inherit (pkgs) substituteAll;
    inherit (pkgsDiet) module_init_tools;
    inherit extraUtils;
    autoDetectRootDevice = config.get ["boot" "autoDetectRootDevice"];
    rootDevice =
      let rootFS = 
        (pkgs.library.findSingle (fs: fs.mountPoint == "/")
          (abort "No root mount point declared.")
          (config.get ["fileSystems"]));
      in if rootFS ? device then rootFS.device else "LABEL=" + rootFS.label;
    rootLabel = config.get ["boot" "rootLabel"];
    inherit stage2Init;
    modulesDir = modulesClosure;
    modules = rootModules;
    staticShell = stdenvLinuxStuff.bootstrapTools.bash;
    staticTools = stdenvLinuxStuff.staticTools;
  };
  

  # The closure of the init script of boot stage 1 is what we put in
  # the initial RAM disk.
  initialRamdisk = import ../boot/make-initrd.nix {
    inherit (pkgs) stdenv cpio;
    contents = [
      { object = bootStage1;
        symlink = "/init";
      }
      { object = extraUtils;
        suffix = "/bin/splash_helper";
        symlink = "/sbin/splash_helper";
      }
      { object = import ../helpers/unpack-theme.nix {
          inherit (pkgs) stdenv;
          theme = config.get ["services" "ttyBackgrounds" "defaultTheme"];
        };
        symlink = "/etc/splash";
      }
    ];
  };


  # The installer.
  nixosInstaller = import ../installer/nixos-installer.nix {
    inherit (pkgs) stdenv runCommand substituteAll;
    inherit nix;
    nixpkgsURL = config.get ["installer" "nixpkgsURL"];
  };


  # The services (Upstart) configuration for the system.
  upstartJobs = import ./upstart.nix {
    inherit config pkgs nix;
  };


  # The static parts of /etc.
  etc = import ./etc.nix {
    inherit pkgs upstartJobs systemPath wrapperDir;
  };


  # The wrapper setuid programs (since we can't have setuid programs
  # in the Nix store).
  wrapperDir = "/var/setuid-wrappers";
  
  setuidWrapper = import ../helpers/setuid {
    inherit (pkgs) stdenv;
    inherit wrapperDir;
  };


  # The packages you want in the boot environment.
  systemPathList = [
    pkgs.bash
    pkgs.bzip2
    pkgs.coreutils
    pkgs.cpio
    pkgs.cron
    pkgs.curl
    pkgs.e2fsprogs
    pkgs.findutils
    pkgs.glibc # for ldd, getent
    pkgs.gnugrep
    pkgs.gnused
    pkgs.gnutar
    pkgs.grub
    pkgs.gzip
    pkgs.iputils
    pkgs.less
    pkgs.lvm2
    pkgs.man
    pkgs.mdadm
    pkgs.module_init_tools
    pkgs.nano
    pkgs.netcat
    pkgs.nettools
    pkgs.ntp
    pkgs.perl
    pkgs.procps
    pkgs.pwdutils
    pkgs.rsync
    pkgs.strace
    pkgs.su
    pkgs.sysklogd
    pkgs.udev
    pkgs.upstart
    pkgs.utillinux
#    pkgs.vim
    nix
    nixosInstaller
    setuidWrapper
  ];


  # We don't want to put all of `startPath' and `path' in $PATH, since
  # then we get an embarrassingly long $PATH.  So use the user
  # environment builder to make a directory with symlinks to those
  # packages.
  systemPath = pkgs.buildEnv {
    name = "system-path";
    paths = systemPathList;
    pathsToLink = ["/bin" "/sbin" "/man" "/share"];
    ignoreCollisions = true;
  };

    
  # The script that activates the configuration, i.e., it sets up
  # /etc, accounts, etc.  It doesn't do anything that can only be done
  # at boot time (such as start `init').
  activateConfiguration = pkgs.substituteAll {
    src = ./activate-configuration.sh;
    isExecutable = true;

    inherit etc wrapperDir systemPath;
    inherit (pkgs) kernel;
    readOnlyRoot = config.get ["boot" "readOnlyRoot"];
    hostName = config.get ["networking" "hostName"];
    setuidPrograms = config.get ["security" "setuidPrograms"];

    path = [
      pkgs.coreutils pkgs.gnugrep pkgs.findutils
      pkgs.glibc # needed for getent
      pkgs.pwdutils
    ];

  };


  # The init script of boot stage 2, which is supposed to do
  # everything else to bring up the system.
  bootStage2 = import ../boot/boot-stage-2.nix {
    inherit (pkgs) substituteAll coreutils 
      utillinux kernel udev upstart;
    inherit activateConfiguration;
    readOnlyRoot = config.get ["boot" "readOnlyRoot"];
    upstartPath = [
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnugrep
      pkgs.gnused
      pkgs.upstart
    ];
  };


  # Script to build the Grub menu containing the current and previous
  # system configurations.
  grubMenuBuilder = pkgs.substituteAll {
    src = ../installer/grub-menu-builder.sh;
    isExecutable = true;
    inherit (pkgs) bash;
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
  };


  # Putting it all together.  This builds a store object containing
  # symlinks to the various parts of the built configuration (the
  # kernel, the Upstart services, the init scripts, etc.) as well as a
  # script `switch-to-configuration' that activates the configuration
  # and makes it bootable.
  system = pkgs.stdenv.mkDerivation {
    name = "system";
    builder = ./system.sh;
    switchToConfiguration = ./switch-to-configuration.sh;
    inherit (pkgs) grub coreutils gnused gnugrep diffutils findutils;
    grubDevice = config.get ["boot" "grubDevice"];
    kernelParams =
      (config.get ["boot" "kernelParams"]) ++
      (config.get ["boot" "extraKernelParams"]);
    inherit bootStage2;
    inherit activateConfiguration;
    inherit grubMenuBuilder;
    inherit etc;
    kernel = pkgs.kernel + "/vmlinuz";
    initrd = initialRamdisk + "/initrd";
    # Most of these are needed by grub-install.
    path = [
      pkgs.coreutils
      pkgs.gnused
      pkgs.gnugrep
      pkgs.findutils
      pkgs.diffutils
      pkgs.upstart # for initctl
    ];
  };


}
