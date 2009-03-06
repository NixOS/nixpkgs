{config, pkgs, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mapAttrs getAttr fold
    mergeListOption mergeTypedOption mergeAttrsWithFunc;

  options = {
    services = {
      extraJobs = mkOption {
        default = [];
        example = [
             { name = "test-job";
               job = ''
                 description "nc"
                 start on started network-interfaces
                 respawn
                 env PATH=/var/run/current-system/sw/bin
                 exec sh -c "echo 'hello world' | ${pkgs.netcat}/bin/nc -l -p 9000"
                 '';
             } ];
        # should have some checks to everify the syntax
        merge = pkgs.lib.mergeListOption;
        description = "
          Additional Upstart jobs.
        ";
      };

      tools = {
        upstartJobs = mkOption {
          default = {};
          description = "
            List of functions which can be used to create upstart-jobs.
          ";
        };
      };
    };

    tests = {
      upstartJobs = mkOption {
        internal = true;
        default = {};
        description = "
          Make it easier to build individual Upstart jobs. (e.g.,
          <command>nix-build /etc/nixos/nixos -A
          tests.upstartJobs.xserver</command>).
        ";
      };
    };
  };
in

###### implementation
let
  # should be moved to the corresponding jobs.
  nix = config.environment.nix;
  nixEnvVars = config.nix.envVars;
  kernelPackages = config.boot.kernelPackages;
  nssModulesPath = config.system.nssModules.path;
  modprobe = config.system.sbin.modprobe;
  mount = config.system.sbin.mount;

  makeJob = import ../upstart-jobs/make-job.nix {
    inherit (pkgs) runCommand;
  };

  optional = cond: service: pkgs.lib.optional cond (makeJob service);

  requiredTTYs = config.requiredTTYs;

  jobs = map makeJob
    ([
    
    # Klogd.
    (import ../upstart-jobs/klogd.nix {
      inherit (pkgs) sysklogd writeText;
      inherit config;
    })

    # The udev daemon creates devices nodes and runs programs when
    # hardware events occur.
    (import ../upstart-jobs/udev.nix {
      inherit modprobe config;
      inherit (pkgs) stdenv writeText substituteAll udev procps;
      inherit (pkgs.lib) cleanSource;
      firmwareDirs = config.services.udev.addFirmware;
      extraUdevPkgs = config.services.udev.addUdevPkgs;
    })
      
    # Makes LVM logical volumes available. 
    (import ../upstart-jobs/lvm.nix {
      inherit modprobe;
      inherit (pkgs) lvm2 devicemapper;
    })
      
    # Activate software RAID arrays.
    (import ../upstart-jobs/swraid.nix {
      inherit modprobe;
      inherit (pkgs) mdadm;
    })
      
    # Mount file systems.
    (import ../upstart-jobs/filesystems.nix {
      inherit mount;
      inherit (pkgs) utillinux e2fsprogs;
      fileSystems = config.fileSystems;
    })

    # Swapping.
    (import ../upstart-jobs/swap.nix {
      inherit (pkgs) utillinux lib;
      swapDevices = config.swapDevices;
    })

    # Network interfaces.
    (import ../upstart-jobs/network-interfaces.nix {
      inherit modprobe config;
      inherit (pkgs) nettools wirelesstools bash writeText;
    })
      
    # Name service cache daemon.
    (import ../upstart-jobs/nscd.nix {
      inherit (pkgs) glibc;
      inherit nssModulesPath;
    })

    # Handles the maintenance/stalled event (single-user shell).
    (import ../upstart-jobs/maintenance-shell.nix {
      inherit (pkgs) bash;
    })

    # Ctrl-alt-delete action.
    (import ../upstart-jobs/ctrl-alt-delete.nix)

  ])

  # ifplugd daemon for monitoring Ethernet cables.
  ++ optional config.networking.interfaceMonitor.enable
    (import ../upstart-jobs/ifplugd.nix {
      inherit (pkgs) ifplugd writeScript bash;
      inherit config;
    })

  # Apache httpd.
  ++ optional (config.services.httpd.enable && !config.services.httpd.experimental)
    (import ../upstart-jobs/httpd.nix {
      inherit config pkgs;
      inherit (pkgs) glibc;
      extraConfig = pkgs.lib.concatStringsSep "\n"
        (map (job: job.extraHttpdConfig) jobs);
    })

  # Apache httpd (new style).
  ++ optional (config.services.httpd.enable && config.services.httpd.experimental)
    (import ../upstart-jobs/apache-httpd {
      inherit config pkgs;
    })

  # MySQL server
  ++ optional config.services.mysql.enable
    (import ../upstart-jobs/mysql.nix {
      inherit config pkgs;
    })

  # Postgres SQL server
  ++ optional config.services.postgresql.enable
    (import ../upstart-jobs/postgresql.nix {
      inherit config pkgs;
    })

  # OpenFire XMPP server
  ++ optional config.services.openfire.enable
    (import ../upstart-jobs/openfire.nix {
      inherit config pkgs;
    })

  # Apache Tomcat service
  ++ optional config.services.tomcat.enable
    (import ../upstart-jobs/tomcat.nix {
      inherit config pkgs;
    })

  # Samba service.
  ++ optional config.services.samba.enable
    (import ../upstart-jobs/samba.nix {
      inherit pkgs;
      inherit (pkgs) glibc samba;
    })

  # CUPS (printing) daemon.
  ++ optional config.services.printing.enable
    (import ../upstart-jobs/cupsd.nix {
      inherit config pkgs modprobe;
    })

  # VSFTPd server
  ++ optional config.services.vsftpd.enable
    (import ../upstart-jobs/vsftpd.nix {
      inherit (pkgs) vsftpd;
      inherit (config.services.vsftpd) anonymousUser 
        writeEnable anonymousUploadEnable anonymousMkdirEnable;
    })

  # X Font Server
  ++ optional config.services.xfs.enable
    (import ../upstart-jobs/xfs.nix {
      inherit config pkgs;
    })

  ++ optional config.services.ircdHybrid.enable
    (import ../upstart-jobs/ircd-hybrid.nix {
      inherit config pkgs;
    })

  # Postfix mail server.
  ++ optional config.services.postfix.enable
    (import ../upstart-jobs/postfix.nix {
      inherit config pkgs;
    })

  # Dovecot POP3/IMAP server.
  ++ optional config.services.dovecot.enable
    (import ../upstart-jobs/dovecot.nix {
      inherit config pkgs;
    })

  # ISC BIND domain name server.
  ++ optional config.services.bind.enable
    (import ../upstart-jobs/bind.nix {
      inherit config pkgs;
    })

  # Handles the reboot/halt events.
  ++ (map
    (event: makeJob (import ../upstart-jobs/halt.nix {
      inherit (pkgs) bash utillinux;
      inherit event;
    }))
    ["reboot" "halt" "system-halt" "power-off"]
  )
    
  # The terminals on ttyX.
  ++ (map 
    (ttyNumber: makeJob (import ../upstart-jobs/mingetty.nix {
        inherit (pkgs) mingetty;
        inherit ttyNumber;
        loginProgram = "${pkgs.pam_login}/bin/login";
    }))
    (config.services.mingetty.ttys)
  )

  # Transparent TTY backgrounds.
  ++ optional (config.services.ttyBackgrounds.enable && kernelPackages.splashutils != null)
    (import ../upstart-jobs/tty-backgrounds.nix {
      inherit (pkgs) stdenv;
      inherit (kernelPackages) splashutils;
      
      backgrounds =
      
        let
        
          specificThemes =
            config.services.ttyBackgrounds.defaultSpecificThemes
            ++ config.services.ttyBackgrounds.specificThemes;
            
          overridenTTYs = map (x: x.tty) specificThemes;

          # Use the default theme for all the mingetty ttys and for the
          # syslog tty, except those for which a specific theme is
          # specified.
          defaultTTYs =
            pkgs.lib.filter (x: !(pkgs.lib.elem x overridenTTYs)) requiredTTYs;

        in      
          (map (ttyNumber: {
            tty = ttyNumber;
            theme = config.services.ttyBackgrounds.defaultTheme;
          }) defaultTTYs)
          ++ specificThemes;
          
    })

  # User-defined events.
  ++ (map makeJob (config.services.extraJobs));


  command = import ../upstart-jobs/gather.nix {
    inherit (pkgs) runCommand;
    inherit jobs;
  };

in 

{
  require = [
    options
    (import ./lib/default.nix)
  ];

  environment = {
    etc = [{ # The Upstart events defined above.
      source = command + "/etc/event.d";
      target = "event.d";
    }]
    ++ pkgs.lib.concatLists (map (job: job.extraEtc) jobs);

    extraPackages =
      pkgs.lib.concatLists (map (job: job.extraPath) jobs);
  };

  users = {
    extraUsers =
      pkgs.lib.concatLists (map (job: job.users) jobs);

    extraGroups =
      pkgs.lib.concatLists (map (job: job.groups) jobs);
  };

  services = {
    extraJobs = [
      # For the built-in logd job.
      { jobDrv = pkgs.upstart; }
    ];
  };

  tests = {
    # see test/test-upstart-job.sh
    upstartJobs = { recurseForDerivations = true; } //
      builtins.listToAttrs (map (job:
        { name = if job ? jobName then job.jobName else job.name; value = job; }
      ) jobs);
  };
}
