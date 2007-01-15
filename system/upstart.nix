{config, pkgs, nix, nssModulesPath}:

let 

  makeJob = import ../upstart-jobs/make-job.nix {
    inherit (pkgs) runCommand;
  };

  optional = option: service:
    if config.get option then [(makeJob service)] else [];

in

import ../upstart-jobs/gather.nix {
  inherit (pkgs) runCommand;

  jobs = map makeJob [
    # Syslogd.
    (import ../upstart-jobs/syslogd.nix {
      inherit (pkgs) sysklogd;
    })

    # The udev daemon creates devices nodes and runs programs when
    # hardware events occur.
    (import ../upstart-jobs/udev.nix {
      inherit (pkgs) writeText udev procps;
      inherit (pkgs.lib) cleanSource;
    })
      
    # Makes LVM logical volumes available. 
    (import ../upstart-jobs/lvm.nix {
      inherit (pkgs) kernel module_init_tools lvm2;
    })
      
    # Activate software RAID arrays.
    (import ../upstart-jobs/swraid.nix {
      inherit (pkgs) kernel module_init_tools mdadm;
    })
      
    # Hardware scan; loads modules for PCI devices.
    (import ../upstart-jobs/hardware-scan.nix {
      inherit (pkgs) kernel module_init_tools;
      doHardwareScan = config.get ["boot" "hardwareScan"];
      kernelModules = config.get ["boot" "kernelModules"];
    })
      
    # Mount file systems.
    (import ../upstart-jobs/filesystems.nix {
      inherit (pkgs) utillinux e2fsprogs;
      fileSystems = config.get ["fileSystems"];
    })

    # Swapping.
    (import ../upstart-jobs/swap.nix {
      inherit (pkgs) utillinux library;
      swapDevices = config.get ["swapDevices"];
    })

    # Network interfaces.
    (import ../upstart-jobs/network-interfaces.nix {
      inherit (pkgs) nettools kernel module_init_tools;
    })
      
    # DHCP client.
    (import ../upstart-jobs/dhclient.nix {
      inherit (pkgs) nettools;
      dhcp = pkgs.dhcpWrapper;
    })

    # Nix daemon - required for multi-user Nix.
    (import ../upstart-jobs/nix-daemon.nix {
      inherit nix;
    })

    # Cron daemon.
    (import ../upstart-jobs/cron.nix {
      inherit (pkgs) cron;
    })

    # Name service cache daemon.
    (import ../upstart-jobs/nscd.nix {
      inherit (pkgs) glibc pwdutils;
      inherit nssModulesPath;
    })

    # Handles the maintenance/stalled event (single-user shell).
    (import ../upstart-jobs/maintenance-shell.nix {
      inherit (pkgs) bash;
    })

    # Ctrl-alt-delete action.
    (import ../upstart-jobs/ctrl-alt-delete.nix)

  ]

  # SSH daemon.
  ++ optional ["services" "sshd" "enable"]
    (import ../upstart-jobs/sshd.nix {
      inherit (pkgs) writeText openssh glibc pwdutils;
      inherit (pkgs.xorg) xauth;
      inherit nssModulesPath;
      forwardX11 = config.get ["services" "sshd" "forwardX11"];
      allowSFTP = config.get ["services" "sshd" "allowSFTP"];
    })

  # NTP daemon.
  ++ optional ["services" "ntp" "enable"]
    (import ../upstart-jobs/ntpd.nix {
      inherit (pkgs) ntp kernel module_init_tools glibc pwdutils writeText;
      servers = config.get ["services" "ntp" "servers"];
    })

  # X server.
  ++ optional ["services" "xserver" "enable"]
    (import ../upstart-jobs/xserver.nix {
      inherit (pkgs) substituteAll;
      inherit (pkgs.xorg) xorgserver xf86inputkeyboard xf86inputmouse xf86videovesa;
    })

  # Apache httpd.
  ++ optional ["services" "httpd" "enable"]
    (import ../upstart-jobs/httpd.nix {
      inherit config pkgs;
      inherit (pkgs) glibc pwdutils;
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
    (config.get ["services" "mingetty" "ttys"])
  )

  # Transparent TTY backgrounds.
  ++ optional ["services" "ttyBackgrounds" "enable"]
    (import ../upstart-jobs/tty-backgrounds.nix {
      inherit (pkgs) stdenv splashutils;
      
      backgrounds =
      
        let
        
          specificThemes =
            config.get ["services" "ttyBackgrounds" "defaultSpecificThemes"]
            ++ config.get ["services" "ttyBackgrounds" "specificThemes"];
            
          overridenTTYs = map (x: x.tty) specificThemes;

          requiredTTYs =
            (config.get ["services" "mingetty" "ttys"])
            ++ [10] /* !!! sync with syslog.conf */ ;

          # Use the default theme for all the mingetty ttys and for the
          # syslog tty, except those for which a specific theme is
          # specified.
          defaultTTYs =
            pkgs.library.filter (x: !(pkgs.library.elem x overridenTTYs)) requiredTTYs;

        in      
          (map (ttyNumber: {
            tty = ttyNumber;
            theme = config.get ["services" "ttyBackgrounds" "defaultTheme"];
          }) defaultTTYs)
          ++ specificThemes;
          
    })

  # User-defined events.
  ++ (map makeJob (config.get ["services" "extraJobs"]))

  # For the built-in logd job.
  ++ [pkgs.upstart];
  
}
