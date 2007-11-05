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

  manifests = config.get ["installer" "manifests"]; # exported here because nixos-rebuild uses it

  nix = pkgs.nixUnstable; # we need the exportReferencesGraph feature

  kernel = (config.get ["boot" "kernel"]) pkgs;

  rootModules = 
    (config.get ["boot" "initrd" "extraKernelModules"]) ++
    (config.get ["boot" "initrd" "kernelModules"]);


  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = import ../helpers/modules-closure.nix {
    inherit (pkgs) stdenv module_init_tools;
    inherit kernel rootModules;
  };


  # Some additional utilities needed in stage 1, notably mount.  We
  # don't want to bring in all of util-linux, so we just copy what we
  # need.
  extraUtils = pkgs.runCommand "extra-utils"
    { buildInputs = [pkgs.nukeReferences];
      inherit (pkgsStatic) utillinux;
      inherit (pkgsDiet) udev;
      e2fsprogs = pkgs.e2fsprogsDiet;
      devicemapper = if config.get ["boot" "initrd" "lvm"] then pkgs.devicemapperStatic else null;
      lvm2 = if config.get ["boot" "initrd" "lvm"] then pkgs.lvm2Static else null;
      allowedReferences = []; # prevent accidents like glibc being included in the initrd
    }
    "
      ensureDir $out/bin
      if test -n \"$devicemapper\"; then
        cp $devicemapper/sbin/dmsetup.static $out/bin/dmsetup
        cp $lvm2/sbin/lvm.static $out/bin/lvm
      fi
      cp $utillinux/bin/mount $utillinux/bin/umount $utillinux/sbin/pivot_root $out/bin
      cp -p $e2fsprogs/sbin/fsck* $e2fsprogs/sbin/e2fsck $out/bin
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
    fileSystems =
      pkgs.lib.filter
        (fs: fs.mountPoint == "/" || (fs ? neededForBoot && fs.neededForBoot))
        (config.get ["fileSystems"]);
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
    inherit (pkgs) perl stdenv cpio;
    contents = [
      { object = bootStage1;
        symlink = "/init";
      }
    ] ++ (if config.get ["boot" "initrd" "enableSplashScreen"] then [
      { object = pkgs.runCommand "splashutils" {} "
          ensureDir $out/bin
          cp ${pkgs.splashutils}/bin/splash_helper $out/bin
        ";
        suffix = "/bin/splash_helper";
        symlink = "/sbin/splash_helper";
      }
      { object = import ../helpers/unpack-theme.nix {
          inherit (pkgs) stdenv;
          theme = config.get ["services" "ttyBackgrounds" "defaultTheme"];
        };
        symlink = "/etc/splash";
      }
    ] else []);
  };


  # The installer.
  nixosInstall = import ../installer/nixos-install.nix {
    inherit (pkgs) perl runCommand substituteAll;
    inherit nix;
    nixpkgsURL = config.get ["installer" "nixpkgsURL"];
  };

  nixosRebuild = import ../installer/nixos-rebuild.nix {
    inherit (pkgs) substituteAll;
  };

  nixosCheckout = import ../installer/nixos-checkout.nix {
    inherit (pkgs) substituteAll;
  };


  # NSS modules.  Hacky!
  nssModules =
    if config.get ["users" "ldap" "enable"] then [pkgs.nss_ldap] else [];

  nssModulesPath = pkgs.lib.concatStrings (pkgs.lib.intersperse ":" 
    (map (mod: mod + "/lib") nssModules));


  # Wrapper around modprobe to set the path to the modules.
  modprobe = pkgs.substituteAll {
    dir = "sbin";
    src = ./modprobe;
    isExecutable = true;
    inherit (pkgs) module_init_tools;
    inherit kernel;
  };


  # The services (Upstart) configuration for the system.
  upstartJobs = import ../upstart-jobs/default.nix {
    inherit config pkgs nix modprobe nssModulesPath;
  };


  # The static parts of /etc.
  etc = import ../etc/default.nix {
    inherit config pkgs upstartJobs systemPath wrapperDir defaultShell;
    extraEtc = pkgs.lib.concatLists (map (job: job.extraEtc) upstartJobs.jobs);
  };

  # Font aggregation
	fontDir = import ./fontdir.nix {
		inherit (pkgs) stdenv;
		inherit pkgs config;
		inherit (pkgs.xorg) mkfontdir mkfontscale fontalias;
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
    modprobe # must take precedence over module_init_tools
    pkgs.bashInteractive # bash with ncurses support
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
    pkgs.openssh
    pkgs.pciutils
    pkgs.perl
    pkgs.procps
    pkgs.pwdutils
    pkgs.rsync
    pkgs.strace
    pkgs.su
    pkgs.sysklogd
    pkgs.sysvtools
    pkgs.time
    pkgs.udev
    pkgs.upstart
    pkgs.utillinux
#    pkgs.vim
    pkgs.wirelesstools
    nix
    nixosInstall
    nixosRebuild
    nixosCheckout
    setuidWrapper
  ]
  ++ pkgs.lib.optional (config.get ["security" "sudo" "enable"]) pkgs.sudo
  ++ pkgs.lib.concatLists (map (job: job.extraPath) upstartJobs.jobs)
  ++ (config.get ["environment" "extraPackages"]) pkgs
  ++ pkgs.lib.optional (config.get ["fonts" "enableFontDir"]) fontDir;


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


  usersGroups = import ./users-groups.nix { inherit pkgs upstartJobs defaultShell; };


  defaultShell = "/var/run/current-system/sw/bin/bash";

    
  # The script that activates the configuration, i.e., it sets up
  # /etc, accounts, etc.  It doesn't do anything that can only be done
  # at boot time (such as start `init').
  activateConfiguration = pkgs.substituteAll {
    src = ./activate-configuration.sh;
    isExecutable = true;

    inherit etc wrapperDir systemPath modprobe defaultShell kernel;
    readOnlyRoot = config.get ["boot" "readOnlyRoot"];
    hostName = config.get ["networking" "hostName"];
    setuidPrograms =
      config.get ["security" "setuidPrograms"] ++
      config.get ["security" "extraSetuidPrograms"] ++
      pkgs.lib.optional (config.get ["security" "sudo" "enable"]) "sudo";

    inherit (usersGroups) createUsersGroups usersList groupsList;

    path = [
      pkgs.coreutils pkgs.gnugrep pkgs.findutils
      pkgs.glibc # needed for getent
      pkgs.pwdutils
    ];

    bash = pkgs.bashInteractive;
  };


  # The init script of boot stage 2, which is supposed to do
  # everything else to bring up the system.
  bootStage2 = import ../boot/boot-stage-2.nix {
    inherit (pkgs) substituteAll writeText coreutils 
      utillinux udev upstart;
    inherit kernel activateConfiguration;
    readOnlyRoot = config.get ["boot" "readOnlyRoot"];
    upstartPath = [
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnugrep
      pkgs.gnused
      pkgs.upstart
    ];
    bootLocal = config.get ["boot" "localCommands"];
  };


  # Script to build the Grub menu containing the current and previous
  # system configurations.
  grubMenuBuilder = pkgs.substituteAll {
    src = ../installer/grub-menu-builder.sh;
    isExecutable = true;
    inherit (pkgs) bash;
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
    copyKernels = config.get ["boot" "copyKernels"];
    extraGrubEntries = config.get ["boot" "extraGrubEntries"];
  };


  # Putting it all together.  This builds a store object containing
  # symlinks to the various parts of the built configuration (the
  # kernel, the Upstart services, the init scripts, etc.) as well as a
  # script `switch-to-configuration' that activates the configuration
  # and makes it bootable.
  system = pkgs.checker (pkgs.stdenv.mkDerivation {
    name = "system";
    builder = ./system.sh;
    switchToConfiguration = ./switch-to-configuration.sh;
    inherit (pkgs) grub coreutils gnused gnugrep diffutils findutils upstart;
    grubDevice = config.get ["boot" "grubDevice"];
    kernelParams =
      (config.get ["boot" "kernelParams"]) ++
      (config.get ["boot" "extraKernelParams"]);
    inherit bootStage2;
    inherit activateConfiguration;
    inherit grubMenuBuilder;
    inherit etc;
    inherit systemPath;
    kernel = kernel + "/vmlinuz";
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
    configurationName = config.get ["boot" "configurationName"];
  }) (pkgs.getConfig ["checkConfigurationOptions"] false) 
	config.declarations configuration ;
}
