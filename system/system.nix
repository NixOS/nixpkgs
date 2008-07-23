{ platform ? __currentSystem
, stage2Init ? ""
, configuration
, nixpkgsPath ? ../../nixpkgs
}:

rec {

  # Make a configuration object from which we can retrieve option
  # values.
  config = pkgs.lib.addDefaultOptionValues optionDeclarations configuration;

  optionDeclarations = import ./options.nix {inherit pkgs; inherit (pkgs.lib) mkOption;};
    

  pkgs = import "${nixpkgsPath}/pkgs/top-level/all-packages.nix" {system = platform;};

  pkgsDiet = import "${nixpkgsPath}/pkgs/top-level/all-packages.nix" {
    system = platform;
    bootStdenv = pkgs.useDietLibC pkgs.stdenv;
  };

  pkgsStatic = import "${nixpkgsPath}/pkgs/top-level/all-packages.nix" {
    system = platform;
    bootStdenv = pkgs.makeStaticBinaries pkgs.stdenv;
  };

  stdenvLinuxStuff = import "${nixpkgsPath}/pkgs/stdenv/linux" {
    system = pkgs.stdenv.system;
    allPackages = import "${nixpkgsPath}/pkgs/top-level/all-packages.nix";
  };

  manifests = config.installer.manifests; # exported here because nixos-rebuild uses it

  nix = config.environment.nix pkgs;

  kernelPackages = config.boot.kernelPackages pkgs;

  kernel = kernelPackages.kernel;

  rootModules = 
    config.boot.initrd.extraKernelModules ++
    config.boot.initrd.kernelModules;



  # Tree of kernel modules.  This includes the kernel, plus modules
  # built outside of the kernel.  We have to combine these into a
  # single tree of symlinks because modprobe only supports one
  # directory.
  modulesTree = pkgs.aggregateModules (
    [kernel]
    ++ pkgs.lib.optional ((config.networking.enableIntel3945ABGFirmware || config.networking.enableIntel4965AGNFirmware) && !kernel.features ? iwlwifi) kernelPackages.iwlwifi
    # !!! this should be declared by the xserver Upstart job.
    ++ pkgs.lib.optional (config.services.xserver.enable && config.services.xserver.videoDriver == "nvidia") kernelPackages.nvidiaDrivers
    ++ pkgs.lib.optional config.hardware.enableGo7007 kernelPackages.wis_go7007
    ++ config.boot.extraModulePackages pkgs
  );

  
  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = pkgs.makeModulesClosure {
    inherit rootModules;
    kernel = modulesTree;
    allowMissing = config.boot.initrd.allowMissing;
  };


  # Some additional utilities needed in stage 1, notably mount.  We
  # don't want to bring in all of util-linux, so we just copy what we
  # need.
  extraUtils = pkgs.runCommand "extra-utils"
    { buildInputs = [pkgs.nukeReferences];
      inherit (pkgsStatic) utillinux;
      inherit (pkgsDiet) udev;
      e2fsprogs = pkgs.e2fsprogsDiet;
      devicemapper = if config.boot.initrd.lvm then pkgs.devicemapperStatic else null;
      lvm2 = if config.boot.initrd.lvm then pkgs.lvm2Static else null;
      allowedReferences = []; # prevent accidents like glibc being included in the initrd
    }
    ''
      ensureDir $out/bin
      if test -n "$devicemapper"; then
        cp $devicemapper/sbin/dmsetup.static $out/bin/dmsetup
        cp $lvm2/sbin/lvm.static $out/bin/lvm
      fi
      cp $utillinux/bin/mount $utillinux/bin/umount $utillinux/sbin/pivot_root $out/bin
      cp -p $e2fsprogs/sbin/fsck* $e2fsprogs/sbin/e2fsck $out/bin
      cp $udev/sbin/udevd $udev/sbin/udevadm $out/bin
      nuke-refs $out/bin/*
    ''; # */
  

  # The init script of boot stage 1 (loading kernel modules for
  # mounting the root FS).
  bootStage1 = import ../boot/boot-stage-1.nix {
    inherit (pkgs) substituteAll;
    inherit (pkgsDiet) module_init_tools;
    inherit extraUtils;
    inherit (config.boot) autoDetectRootDevice isLiveCD;
    fileSystems =
      pkgs.lib.filter
        (fs: fs.mountPoint == "/" || (fs ? neededForBoot && fs.neededForBoot))
        config.fileSystems;
    rootLabel = config.boot.rootLabel;
    inherit stage2Init;
    modulesDir = modulesClosure;
    modules = rootModules;
    staticShell = stdenvLinuxStuff.bootstrapTools.bash;
    staticTools = stdenvLinuxStuff.staticTools;
    resumeDevice = config.boot.resumeDevice;
  };
  

  # The closure of the init script of boot stage 1 is what we put in
  # the initial RAM disk.
  initialRamdisk = pkgs.makeInitrd {
    contents = [
      { object = bootStage1;
        symlink = "/init";
      }
    ] ++
      pkgs.lib.optionals
        (config.boot.initrd.enableSplashScreen && kernelPackages.splashutils != null)
        [
          { object = pkgs.runCommand "splashutils" {allowedReferences = []; buildInputs = [pkgs.nukeReferences];} ''
              ensureDir $out/bin
              cp ${kernelPackages.splashutils}/${kernelPackages.splashutils.helperName} $out/bin/splash_helper
              nuke-refs $out/bin/*
            '';
            suffix = "/bin/splash_helper";
            symlink = "/${kernelPackages.splashutils.helperName}";
          } # */
          { object = import ../helpers/unpack-theme.nix {
              inherit (pkgs) stdenv;
              theme = config.services.ttyBackgrounds.defaultTheme;
            };
            symlink = "/etc/splash";
          }
        ];
  };


  # NixOS installation/updating tools.
  nixosTools = import ../installer {
    inherit pkgs config nix nixpkgsPath;
  };


  # NSS modules.  Hacky!
  nssModules =
       pkgs.lib.optional config.users.ldap.enable pkgs.nss_ldap
    ++ pkgs.lib.optional config.services.avahi.nssmdns pkgs.nssmdns;

  nssModulesPath = pkgs.lib.concatStrings (pkgs.lib.intersperse ":" 
    (map (mod: mod + "/lib") nssModules));


  # Wrapper around modprobe to set the path to the modules.
  modprobe = pkgs.substituteAll {
    dir = "sbin";
    src = ./modprobe;
    isExecutable = true;
    inherit (pkgs) module_init_tools;
    inherit modulesTree;
  };


  # Environment variables for running Nix.
  nixEnvVars =
    "export NIX_CONF_DIR=/nix/etc/nix\n" +
    (if config.nix.distributedBuilds then
      "export NIX_BUILD_HOOK=${nix}/libexec/nix/build-remote.pl\n" +
      "export NIX_REMOTE_SYSTEMS=/etc/nix.machines\n" +
      "export NIX_CURRENT_LOAD=/var/run/nix/current-load\n"
    else "");

              
  # The services (Upstart) configuration for the system.
  upstartJobs = import ../upstart-jobs/default.nix {
    inherit config pkgs nix modprobe nssModulesPath nixEnvVars
      optionDeclarations kernelPackages;
  };


  # The static parts of /etc.
  etc = import ../etc/default.nix {
    inherit config pkgs upstartJobs systemPath wrapperDir
      defaultShell nixEnvVars modulesTree nssModulesPath;
    extraEtc = pkgs.lib.concatLists (map (job: job.extraEtc) upstartJobs.jobs);
  };

  # Font aggregation
  fontDir = import ./fontdir.nix {
    inherit config pkgs ;
    inherit (pkgs) builderDefs ttmkfdir;
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
    # Better leave them here - they are small, needed,
    # and hard to refer from anywhere outside.
    modprobe # must take precedence over module_init_tools
    nix
    nixosTools.nixosInstall
    nixosTools.nixosRebuild
    nixosTools.nixosCheckout
    nixosTools.nixosHardwareScan
    nixosTools.nixosGenSeccureKeys
    setuidWrapper
  ]
  ++ pkgs.lib.optionals (!config.environment.cleanStart) [
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
    pkgs.ncurses
    pkgs.netcat
    pkgs.nettools
    pkgs.ntp
    pkgs.openssh
    pkgs.pciutils
    pkgs.perl
    pkgs.procps
    pkgs.pwdutils
    pkgs.reiserfsprogs
    pkgs.rsync
    pkgs.seccureUser
    pkgs.strace
    pkgs.su
    pkgs.sysklogd
    pkgs.sysvtools
    pkgs.time
    pkgs.udev
    pkgs.upstart
    pkgs.usbutils
    pkgs.utillinux
    pkgs.wirelesstools
  ]
  ++ pkgs.lib.optional config.security.sudo.enable pkgs.sudo
  ++ pkgs.lib.optional config.services.atd.enable pkgs.at
  ++ pkgs.lib.optional config.services.bitlbee.enable pkgs.bitlbee
  ++ pkgs.lib.optional config.services.avahi.enable pkgs.avahi
  ++ pkgs.lib.optional config.networking.defaultMailServer.directDelivery pkgs.ssmtp 
  ++ pkgs.lib.concatLists (map (job: job.extraPath) upstartJobs.jobs)
  ++ config.environment.extraPackages pkgs
  ++ pkgs.lib.optional config.fonts.enableFontDir fontDir
  ++ pkgs.lib.optional config.hardware.enableGo7007 kernelPackages.wis_go7007

  # NSS modules need to be in `systemPath' so that (i) the builder
  # chroot gets to seem them, and (ii) applications can benefit from
  # changes in the list of NSS modules at run-time, without requiring
  # a reboot.
  ++ nssModules;

  # We don't want to put all of `startPath' and `path' in $PATH, since
  # then we get an embarrassingly long $PATH.  So use the user
  # environment builder to make a directory with symlinks to those
  # packages.
  systemPath = pkgs.buildEnv {
    name = "system-path";
    paths = systemPathList;

    # Note: We need `/lib' to be among `pathsToLink' for NSS modules
    # to work.
    inherit (config.environment) pathsToLink;

    ignoreCollisions = true;
  };


  usersGroups = import ./users-groups.nix { inherit pkgs config upstartJobs defaultShell; };


  defaultShell = "/var/run/current-system/sw/bin/bash";

    
  # The script that activates the configuration, i.e., it sets up
  # /etc, accounts, etc.  It doesn't do anything that can only be done
  # at boot time (such as start `init').
  activateConfiguration = pkgs.substituteAll rec {
    src = ./activate-configuration.sh;
    isExecutable = true;

    inherit etc wrapperDir systemPath modprobe defaultShell kernel;
    hostName = config.networking.hostName;
    setuidPrograms =
      config.security.setuidPrograms ++
      config.security.extraSetuidPrograms ++
      pkgs.lib.optional config.security.sudo.enable "sudo" ++
      pkgs.lib.optionals config.services.atd.enable ["at" "atq" "atrm"] ++
      pkgs.lib.optional (config.services.xserver.sessionType == "kde") "kcheckpass";

    inherit (usersGroups) createUsersGroups usersList groupsList;

    path = [
        pkgs.coreutils pkgs.gnugrep pkgs.findutils
        pkgs.glibc # needed for getent
        pkgs.pwdutils
      ];

    bash = pkgs.bashInteractive;

    adjustSetuidOwner = pkgs.lib.concatStrings (map 
      (_entry:let entry = {
        owner = "nobody";
	group = "nogroup";
	setuid = false;
	setgid = false;
      } //_entry; in
      ''
        chown ${entry.owner}.${entry.group} $wrapperDir/${entry.program}
	chmod u${if entry.setuid then "+" else "-"}s $wrapperDir/${entry.program} 
	chmod g${if entry.setgid then "+" else "-"}s $wrapperDir/${entry.program} 

      '') 
      config.security.setuidOwners);
  };


  # The init script of boot stage 2, which is supposed to do
  # everything else to bring up the system.
  bootStage2 = import ../boot/boot-stage-2.nix {
    inherit (pkgs) substituteAll writeText coreutils 
      utillinux udev upstart;
    inherit kernel activateConfiguration;
    inherit (config.boot) isLiveCD;
    upstartPath = [
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnugrep
      pkgs.gnused
      pkgs.upstart
    ];
    bootLocal = config.boot.localCommands;
  };


  # Script to build the Grub menu containing the current and previous
  # system configurations.
  grubMenuBuilder = pkgs.substituteAll {
    src = ../installer/grub-menu-builder.sh;
    isExecutable = true;
    inherit (pkgs) bash;
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
    inherit (config.boot) copyKernels extraGrubEntries extraGrubEntriesBeforeNixos
      grubSplashImage bootMount configurationLimit;
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
    grubDevice = config.boot.grubDevice;
    kernelParams =
      config.boot.kernelParams ++ config.boot.extraKernelParams;
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
    children = map (x: ((import ./system.nix) 
      {inherit platform stage2Init; 
        configuration = x//{boot=((x.boot)//{grubDevice = "";});};}).system) 
      config.nesting.children; 
    configurationName = config.boot.configurationName;
  }) (pkgs.lib.getAttr ["environment" "checkConfigurationOptions"] 
  	optionDeclarations.environment.checkConfigurationOptions.default
	configuration) 
		optionDeclarations configuration ;
}
