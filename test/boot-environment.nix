{ system ? __currentSystem
, autoDetectRootDevice ? false
, rootDevice ? ""
, rootLabel ? ""
, stage2Init
, readOnlyRoot
}:

rec {

  pkgs = import ./pkgs/top-level/all-packages.nix {inherit system;};

  pkgsDiet = import ./pkgs/top-level/all-packages.nix {
    inherit system;
    bootStdenv = pkgs.useDietLibC pkgs.stdenv;
  };

  pkgsStatic = import ./pkgs/top-level/all-packages.nix {
    inherit system;
    bootStdenv = pkgs.makeStaticBinaries pkgs.stdenv;
  };

  stdenvLinuxStuff = import ./pkgs/stdenv/linux {
    system = pkgs.stdenv.system;
    allPackages = import ./pkgs/top-level/all-packages.nix;
  };

  nix = pkgs.nixUnstable; # we need the exportReferencesGraph feature


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
      "source $stdenv/setup; ensureDir $out/bin; cp $utillinux/bin/mount $utillinux/bin/umount $utillinux/sbin/pivot_root $out/bin; nuke-refs $out/bin/*";
    buildInputs = [pkgs.nukeReferences];
    inherit (pkgsStatic) utillinux;
  };
  

  # The init script of boot stage 1 (loading kernel modules for
  # mounting the root FS).
  bootStage1 = import ./boot-stage-1.nix {
    inherit (pkgs) genericSubstituter;
    inherit (pkgsDiet) module_init_tools;
    inherit extraUtils;
    inherit autoDetectRootDevice rootDevice rootLabel;
    inherit stage2Init;
    modules = modulesClosure;
    shell = stdenvLinuxStuff.bootstrapTools.bash;
    staticTools = stdenvLinuxStuff.staticTools;
  };
  

  # The closure of the init script of boot stage 1 is what we put in
  # the initial RAM disk.
  initialRamdisk = import ./make-initrd.nix {
    inherit (pkgs) stdenv cpio;
    init = bootStage1;
  };


  # The installer.
  nixosInstaller = import ./installer.nix {
    inherit (pkgs) stdenv genericSubstituter;
    inherit nix;
    shell = pkgs.bash + "/bin/sh";
  };


  # The services (Upstart) configuration for the system.
  upstartJobs = import ./upstart-jobs/gather.nix {
    inherit (pkgs) stdenv;

    jobs = map makeJob [
      # Syslogd.
      (import ./upstart-jobs/syslogd.nix {
        inherit (pkgs) sysklogd;
      })

      # Network interfaces.
      (import ./upstart-jobs/network-interfaces.nix {
        inherit (pkgs) nettools kernel;
      })
      
      # DHCP client.
      (import ./upstart-jobs/dhclient.nix {
        dhcp = pkgs.dhcpWrapper;
      })
    ]

    # The terminals on ttyX.
    ++ (map 
      (ttyNumber: makeJob (import ./upstart-jobs/mingetty.nix {
        mingetty = pkgs.mingettyWrapper;
        inherit ttyNumber;
      }))
      [1 2 3 4 5 6]
    )

    # For the builtin logd job.
    ++ [pkgs.upstart];
  };

  
  makeJob = import ./upstart-jobs/make-job.nix {
    inherit (pkgs) stdenv;
  };


  # The init script of boot stage 2, which is supposed to do
  # everything else to bring up the system.
  bootStage2 = import ./boot-stage-2.nix {
    inherit (pkgs) genericSubstituter coreutils findutils
      utillinux kernel udev module_init_tools
      upstart;
    inherit upstartJobs;
    shell = pkgs.bash + "/bin/sh";

    # Additional stuff; add whatever you want here.
    path = [
      pkgs.bash
      pkgs.bzip2
      pkgs.cpio
      pkgs.curl
      pkgs.e2fsprogs
      pkgs.gnugrep
      pkgs.gnused
      pkgs.gnutar
      pkgs.grub
      pkgs.gzip
      pkgs.iputils
      pkgs.less
      pkgs.nano
      pkgs.netcat
      pkgs.nettools
      pkgs.perl
      pkgs.procps
      pkgs.rsync
      pkgs.shadowutils
      pkgs.strace
      pkgs.sysklogd
#      pkgs.sysvinit
#      pkgs.vim
      nix
      nixosInstaller
    ];

    inherit readOnlyRoot;
  };


}
