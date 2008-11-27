{ platform ? __currentSystem
, configuration
, nixpkgsPath ? ../../nixpkgs
}:

rec {

  configComponents = [
    configuration
    (import ./options.nix)
  ];

  noOption = name: values:
    abort "${name}: Used without option declaration.";

  # Make a configuration object from which we can retrieve option
  # values.
  config =
    pkgs.lib.fixOptionSets
      (pkgs.lib.mergeOptionSets noOption)
      pkgs configComponents;

  optionDeclarations =
    pkgs.lib.fixOptionSetsFun
      pkgs.lib.filterOptionSets
      pkgs configComponents
      config;

  pkgs = import "${nixpkgsPath}/pkgs/top-level/all-packages.nix" {system = platform;};

  manifests = config.installer.manifests; # exported here because nixos-rebuild uses it

  nix = config.environment.nix;

  kernelPackages = config.boot.kernelPackages;

  kernel = kernelPackages.kernel;


  # Tree of kernel modules.  This includes the kernel, plus modules
  # built outside of the kernel.  We have to combine these into a
  # single tree of symlinks because modprobe only supports one
  # directory.
  modulesTree = pkgs.aggregateModules (
    [kernel]
    # Merged into mainline kernel
    # ++ pkgs.lib.optional ((config.networking.enableIntel3945ABGFirmware || config.networking.enableIntel4965AGNFirmware) && !kernel.features ? iwlwifi) kernelPackages.iwlwifi
    # !!! this should be declared by the xserver Upstart job.
    ++ pkgs.lib.optional (config.services.xserver.enable && config.services.xserver.videoDriver == "nvidia") kernelPackages.nvidiaDrivers
    ++ pkgs.lib.optional config.hardware.enableGo7007 kernelPackages.wis_go7007
    ++ config.boot.extraModulePackages
  );


  # The initial ramdisk.
  initialRamdiskStuff = import ../boot/boot-stage-1.nix {
    inherit pkgs config nixpkgsPath kernelPackages modulesTree;
  };

  initialRamdisk = initialRamdiskStuff.initialRamdisk;


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
    ''
      export NIX_CONF_DIR=/nix/etc/nix

      # Enable the copy-from-other-stores substituter, which allows builds
      # to be sped up by copying build results from remote Nix stores.  To
      # do this, mount the remote file system on a subdirectory of
      # /var/run/nix/remote-stores.
      export NIX_OTHER_STORES=/var/run/nix/remote-stores/*/nix
      
    '' + # */
    (if config.nix.distributedBuilds then
      ''
        export NIX_BUILD_HOOK=${nix}/libexec/nix/build-remote.pl
        export NIX_REMOTE_SYSTEMS=/etc/nix.machines
        export NIX_CURRENT_LOAD=/var/run/nix/current-load
      ''
    else "");

              
  # The services (Upstart) configuration for the system.
  upstartJobs = import ../upstart-jobs/default.nix {
    inherit config pkgs nix modprobe nssModulesPath nixEnvVars
      optionDeclarations kernelPackages mount;
  };


  # The static parts of /etc.
  etc = import ../etc/default.nix {
    inherit config pkgs upstartJobs systemPath wrapperDir
      defaultShell nixEnvVars modulesTree nssModulesPath;
    extraEtc =
       (pkgs.lib.concatLists (map (job: job.extraEtc) upstartJobs.jobs))
    ++ config.environment.etc;
  };

  
  # Font aggregation
  fontDir = import ./fontdir.nix {
    inherit config pkgs;
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


  # A patched `mount' command that looks in a directory in the Nix
  # store instead of in /sbin for mount helpers (like mount.ntfs-3g or
  # mount.cifs).
  mount = import "${nixpkgsPath}/pkgs/os-specific/linux/util-linux" {
    inherit (pkgs) fetchurl stdenv;
    buildMountOnly = true;
    mountHelpers = pkgs.buildEnv {
      name = "mount-helpers";
      paths = [
        pkgs.ntfs3g
        pkgs.mount_cifs
      ];
      pathsToLink = "/sbin";
    } + "/sbin";
  };
  

  # The packages you want in the boot environment.
  systemPathList = [
    # Better leave them here - they are small, needed,
    # and hard to refer from anywhere outside.
    modprobe # must take precedence over module_init_tools
    mount # must take precedence over util-linux
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
    pkgs.curl
    pkgs.e2fsprogs
    pkgs.findutils
    pkgs.glibc # for ldd, getent
    pkgs.gnugrep
    pkgs.gnused
    pkgs.gnutar
    pkgs.grub
    pkgs.gzip
    pkgs.host
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
  ++ config.environment.extraPackages
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
      pkgs.lib.optional (config.services.xserver.sessionType == "kde") "kcheckpass" ++
      map ( x : x.program ) config.security.setuidOwners;

    inherit (usersGroups) createUsersGroups usersList groupsList;

    path = [
        pkgs.coreutils pkgs.gnugrep pkgs.findutils
        pkgs.glibc # needed for getent
        pkgs.pwdutils
      ];

    bash = pkgs.bashInteractive;

    adjustSetuidOwner = pkgs.lib.concatStrings (map 
      (_entry: let entry = {
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
    # !!! wtf does this do???
    children = map (x: ((import ./system.nix) 
      { inherit platform; 
        configuration = x//{boot=((x.boot)//{grubDevice = "";});};}).system) 
      config.nesting.children; 
    configurationName = config.boot.configurationName;
  }) config.environment.checkConfigurationOptions
     optionDeclarations config;

}
