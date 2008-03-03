{config, pkgs, nix, modprobe, nssModulesPath, nixEnvVars}:

let 

  makeJob = import ../upstart-jobs/make-job.nix {
    inherit (pkgs) runCommand;
  };

  optional = cond: service: pkgs.lib.optional cond (makeJob service);

  requiredTTYs =
    config.services.mingetty.ttys
    ++ config.boot.extraTTYs
    ++ [config.services.syslogd.tty];

    
  jobs = map makeJob [
    # Syslogd.
    (import ../upstart-jobs/syslogd.nix {
      inherit (pkgs) sysklogd;
    })

    # The udev daemon creates devices nodes and runs programs when
    # hardware events occur.
    (import ../upstart-jobs/udev.nix {
      inherit (pkgs) stdenv writeText substituteAll udev procps;
      inherit (pkgs.lib) cleanSource;
      firmwareDirs =
           pkgs.lib.optional config.networking.enableIntel2200BGFirmware pkgs.ipw2200fw
        ++ pkgs.lib.optional config.networking.enableIntel3945ABGFirmware pkgs.iwlwifi3945ucode
        ++ pkgs.lib.optional config.networking.enableIntel4965AGNFirmware pkgs.iwlwifi4965ucode
        ++ pkgs.lib.optional config.networking.enableZydasZD1211Firmware pkgs.zd1211fw
	++ config.services.udev.addFirmware;
      extraUdevPkgs =
           pkgs.lib.optional config.services.hal.enable pkgs.hal
        ++ pkgs.lib.optional config.hardware.enableGo7007 pkgs.wis_go7007;
      sndMode = config.services.udev.sndMode;
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
      
    # Hardware scan; loads modules for PCI devices.
    (import ../upstart-jobs/hardware-scan.nix {
      inherit modprobe;
      doHardwareScan = config.boot.hardwareScan;
      kernelModules = config.boot.kernelModules;
    })
      
    # Mount file systems.
    (import ../upstart-jobs/filesystems.nix {
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
      
    # Nix daemon - required for multi-user Nix.
    (import ../upstart-jobs/nix-daemon.nix {
      inherit config pkgs nix nixEnvVars;
    })

    # Cron daemon.
    (import ../upstart-jobs/cron.nix {
      inherit config pkgs;
    })

    # Name service cache daemon.
    (import ../upstart-jobs/nscd.nix {
      inherit (pkgs) glibc;
      inherit nssModulesPath;
    })

    # Console font and keyboard maps.
    (import ../upstart-jobs/kbd.nix {
      inherit (pkgs) glibc kbd gzip;
      ttyNumbers = requiredTTYs;
      defaultLocale = config.i18n.defaultLocale;
      consoleFont = config.i18n.consoleFont;
      consoleKeyMap = config.i18n.consoleKeyMap;
    })

    # Handles the maintenance/stalled event (single-user shell).
    (import ../upstart-jobs/maintenance-shell.nix {
      inherit (pkgs) bash;
    })

    # Ctrl-alt-delete action.
    (import ../upstart-jobs/ctrl-alt-delete.nix)

  ]

  # DHCP client.
  ++ optional config.networking.useDHCP
    (import ../upstart-jobs/dhclient.nix {
      inherit (pkgs) nettools dhcp lib;
      interfaces = config.networking.interfaces;
    })

  # ifplugd daemon for monitoring Ethernet cables.
  ++ optional config.networking.interfaceMonitor.enable
    (import ../upstart-jobs/ifplugd.nix {
      inherit (pkgs) ifplugd writeScript bash;
      inherit config;
    })

  # DHCP server.
  ++ optional config.services.dhcpd.enable
    (import ../upstart-jobs/dhcpd.nix {
      inherit pkgs config;
    })

  # SSH daemon.
  ++ optional config.services.sshd.enable
    (import ../upstart-jobs/sshd.nix {
      inherit (pkgs) writeText openssh glibc;
      inherit (pkgs.xorg) xauth;
      inherit nssModulesPath;
      forwardX11 = config.services.sshd.forwardX11;
      allowSFTP = config.services.sshd.allowSFTP;
    })

  # NTP daemon.
  ++ optional config.services.ntp.enable
    (import ../upstart-jobs/ntpd.nix {
      inherit modprobe;
      inherit (pkgs) ntp glibc writeText;
      servers = config.services.ntp.servers;
    })

  # X server.
  ++ optional config.services.xserver.enable
    (import ../upstart-jobs/xserver.nix {
      inherit config pkgs;
      fontDirectories = import ../system/fonts.nix {inherit pkgs config;};
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

  # EJabberd service
  ++ optional config.services.ejabberd.enable
    (import ../upstart-jobs/ejabberd.nix {
      inherit config pkgs;
    })  

  # OpenFire XMPP server
  ++ optional config.services.openfire.enable
    (import ../upstart-jobs/openfire.nix {
      inherit config pkgs;
    })

  # JBoss service
  ++ optional config.services.jboss.enable
    (import ../upstart-jobs/jboss.nix {
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
      inherit (pkgs) writeText cups;
    })

  # Gateway6
  ++ optional config.services.gw6c.enable
    (import ../upstart-jobs/gw6c.nix {
      inherit config pkgs;
    })

  # VSFTPd server
  ++ optional config.services.vsftpd.enable
    (import ../upstart-jobs/vsftpd.nix {
      inherit (pkgs) vsftpd;
      inherit (config.services.vsftpd) anonymousUser;
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

  ++ optional config.services.bitlbee.enable
    (import ../upstart-jobs/bitlbee.nix {
      inherit (pkgs) bitlbee;
      inherit (config.services.bitlbee) portNumber interface;
    })

  # ALSA sound support.
  ++ optional config.sound.enable
    (import ../upstart-jobs/alsa.nix {
      inherit modprobe;
      inherit (pkgs) alsaUtils;
    })

  # D-Bus system-wide daemon.
  ++ optional config.services.dbus.enable
    (import ../upstart-jobs/dbus.nix {
      inherit (pkgs) stdenv dbus;
      dbusServices =
        pkgs.lib.optional (config.services.hal.enable) pkgs.hal;
    })

  # HAL daemon.
  ++ optional config.services.hal.enable
    (import ../upstart-jobs/hal.nix {
      inherit (pkgs) stdenv hal;
    })

  # Nagios system/network monitoring daemon.
  ++ optional config.services.nagios.enable
    (import ../upstart-jobs/nagios {
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
  ++ optional config.services.ttyBackgrounds.enable
    (import ../upstart-jobs/tty-backgrounds.nix {
      inherit (pkgs) stdenv splashutils;
      
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
  ++ (map makeJob (config.services.extraJobs))

  # For the built-in logd job.
  ++ [(makeJob { jobDrv = pkgs.upstart; })];

  
in import ../upstart-jobs/gather.nix {
  inherit (pkgs) runCommand;
  inherit jobs;
}
