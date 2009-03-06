{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mergeOneOption;
in

{

  time = {

    timeZone = mkOption {
      default = "CET";
      example = "America/New_York";
      description = "The time zone used when displaying times and dates.";
    };

  };

  
  boot = {

    isLiveCD = mkOption {
      default = false;
      description = "
        If set to true, the root device will be mounted read-only and
        a ramdisk will be mounted on top of it using unionfs to
        provide a writable root.  This is used for the NixOS
        Live-CD/DVD.
      ";
    };

    resumeDevice = mkOption {
      default = "";
      example = "0:0";
      description = "
        Device for manual resume attempt during boot. Looks like 
        major:minor. ls -l /dev/SWAP_PARTION shows them.
      ";
    };

    hardwareScan = mkOption {
      default = true;
      description = "
        Whether to try to load kernel modules for all detected hardware.
        Usually this does a good job of providing you with the modules
        you need, but sometimes it can crash the system or cause other
        nasty effects.  If the hardware scan is turned on, it can be
        disabled at boot time by adding the <literal>safemode</literal>
        parameter to the kernel command line.
      ";
    };

    initrd = {

      allowMissing = mkOption {
        default = false;
        description = ''
          Allow some initrd components to be missing. Useful for
          custom kernel that are changed too often to track needed
          kernelModules.
        '';
      };

      lvm = mkOption {
        default = true;
        description = "
          Whether to include lvm in the initial ramdisk. You should use this option
          if your ROOT device is on lvm volume.
        ";
      };

      enableSplashScreen = mkOption {
        default = true;
        description = "
          Whether to show a nice splash screen while booting.
        ";
      };

    };
    
    copyKernels = mkOption {
      default = false;
      description = "
        Whether the Grub menu builder should copy kernels and initial
        ramdisks to /boot.  This is necessary when /nix is on a
        different file system than /boot.
      ";
    };

    localCommands = mkOption {
      default = "";
      example = "text=anything; echo You can put $text here.";
      description = "
        Shell commands to be executed just before Upstart is started.
      ";
    };

    extraTTYs = mkOption {
      default = [];
      example = [8 9];
      description = "
        Tty (virtual console) devices, in addition to the consoles on
        which mingetty and syslogd run, that must be initialised.
        Only useful if you have some program that you want to run on
        some fixed console.  For example, the NixOS installation CD
        opens the manual in a web browser on console 7, so it sets
        <option>boot.extraTTYs</option> to <literal>[7]</literal>.
      ";
    };

  };

  system = {
    # NSS modules.  Hacky!
    nssModules = mkOption {
      internal = true;
      default = [];
      description = "
        Search path for NSS (Name Service Switch) modules.  This allows
        several DNS resolution methods to be specified via
        <filename>/etc/nsswitch.conf</filename>.
      ";
      merge = pkgs.lib.mergeListOption;
      apply = list:
        let
          list2 =
             list
          ++ pkgs.lib.optional config.users.ldap.enable pkgs.nss_ldap;
        in {
          list = list2;
          path = pkgs.lib.makeLibraryPath list2;
        };
    };

    modulesTree = mkOption {
      internal = true;
      default = [];
      description = "
        Tree of kernel modules.  This includes the kernel, plus modules
        built outside of the kernel.  Combine these into a single tree of
        symlinks because modprobe only supports one directory.
      ";
      merge = pkgs.lib.mergeListOption;

      # Convert the list of path to only one path.
      apply = pkgs.aggregateModules;
    };

    sbin = {
      modprobe = mkOption {
        # should be moved in module-init-tools
        internal = true;
        default = pkgs.substituteAll {
          dir = "sbin";
          src = ./modprobe;
          isExecutable = true;
          inherit (pkgs) module_init_tools;
          inherit (config.system) modulesTree;
        };
        description = "
          Path to the modprobe binary used by the system.
        ";
      };

      mount = mkOption {
        internal = true;
        default = pkgs.utillinux.passthru.function {
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
        description = "
          Install a special version of mount to search mount tools in
          unusual path.
        ";
      };
    };
  };


  networking = {

    hostName = mkOption {
      default = "nixos";
      description = "
        The name of the machine.  Leave it empty if you want to obtain
        it from a DHCP server (if using DHCP).
      ";
    };

    nativeIPv6 = mkOption {
      default = false;
      description = "
        Whether to use IPv6 even though gw6c is not used. For example, 
        for Postfix.
      ";
    };

    extraHosts = mkOption {
      default = "";
      example = "192.168.0.1 lanlocalhost";
      description = ''
        Additional entries to be appended to <filename>/etc/hosts</filename>.
      '';
    };

    defaultGateway = mkOption {
      default = "";
      example = "131.211.84.1";
      description = "
        The default gateway.  It can be left empty if it is auto-detected through DHCP.
      ";
    };

    nameservers = mkOption {
      default = [];
      example = ["130.161.158.4" "130.161.33.17"];
      description = "
        The list of nameservers.  It can be left empty if it is auto-detected through DHCP.
      ";
    };

    domain = mkOption {
      default = "";
      example = "home";
      description = "
        The domain.  It can be left empty if it is auto-detected through DHCP.
      ";
    };

    localCommands = mkOption {
      default = "";
      example = "text=anything; echo You can put $text here.";
      description = "
        Shell commands to be executed at the end of the
        <literal>network-interfaces</literal> Upstart job.  Note that if
        you are using DHCP to obtain the network configuration,
        interfaces may not be fully configured yet.
      ";
    };

    interfaceMonitor = {

      enable = mkOption {
        default = false;
        description = "
          If <literal>true</literal>, monitor Ethernet interfaces for
          cables being plugged in or unplugged.  When this occurs, the
          <command>dhclient</command> service is restarted to
          automatically obtain a new IP address.  This is useful for
          roaming users (laptops).
        ";
      };

      beep = mkOption {
        default = false;
        description = "
          If <literal>true</literal>, beep when an Ethernet cable is
          plugged in or unplugged.
        ";
      };

    };

    defaultMailServer = {

      directDelivery = mkOption {
        default = false;
        example = true;
        description = "
          Use the trivial Mail Transfer Agent (MTA)
          <command>ssmtp</command> package to allow programs to send
          e-mail.  If you don't want to run a ``real'' MTA like
          <command>sendmail</command> or <command>postfix</command> on
          your machine, set this option to <literal>true</literal>, and
          set the option
          <option>networking.defaultMailServer.hostName</option> to the
          host name of your preferred mail server.
        ";
      };

      hostName = mkOption {
        example = "mail.example.org";
        description = "
          The host name of the default mail server to use to deliver
          e-mail.
        ";
      };

      domain = mkOption {
        default = "";
        example = "example.org";
        description = "
          The domain from which mail will appear to be sent.
        ";
      };

      useTLS = mkOption {
        default = false;
        example = true;
        description = "
          Whether TLS should be used to connect to the default mail
          server.
        ";
      };

      useSTARTTLS = mkOption {
        default = false;
        example = true;
        description = "
          Whether the STARTTLS should be used to connect to the default
          mail server.  (This is needed for TLS-capable mail servers
          running on the default SMTP port 25.)
        ";
      };

    };

  };


  fileSystems = mkOption {
    default = [];
    example = [
      { mountPoint = "/";
        device = "/dev/hda1";
      }
      { mountPoint = "/data";
        device = "/dev/hda2";
        fsType = "ext3";
        options = "data=journal";
      }
      { mountPoint = "/bigdisk";
        label = "bigdisk";
      }
    ];
    description = "
      The file systems to be mounted.  It must include an entry for
      the root directory (<literal>mountPoint = \"/\"</literal>).  Each
      entry in the list is an attribute set with the following fields:
      <literal>mountPoint</literal>, <literal>device</literal>,
      <literal>fsType</literal> (a file system type recognised by
      <command>mount</command>; defaults to
      <literal>\"auto\"</literal>), and <literal>options</literal>
      (the mount options passed to <command>mount</command> using the
      <option>-o</option> flag; defaults to <literal>\"defaults\"</literal>).

      Instead of specifying <literal>device</literal>, you can also
      specify a volume label (<literal>label</literal>) for file
      systems that support it, such as ext2/ext3 (see <command>mke2fs
      -L</command>).

      <literal>autocreate</literal> forces <literal>mountPoint</literal> to be created with 
      <command>mkdir -p</command> .
    ";
  };


  swapDevices = mkOption {
    default = [];
    example = [
      { device = "/dev/hda7"; }
      { device = "/var/swapfile"; }
      { label = "bigswap"; }
    ];
    description = "
      The swap devices and swap files.  These must have been
      initialised using <command>mkswap</command>.  Each element
      should be an attribute set specifying either the path of the
      swap device or file (<literal>device</literal>) or the label
      of the swap device (<literal>label</literal>, see
      <command>mkswap -L</command>).  Using a label is
      recommended.
    ";
  };

  nesting = {
    children = mkOption {
      default = [];
      description = "
        Additional configurations to build.
      ";
    };
  };

  
  passthru = mkOption {
    default = {};
    description = "
      Additional parameters. Ignored. When you want to be sure that 
      /etc/nixos/nixos -A config.passthru.* is that same thing the 
      system rebuild will use.
    ";
  };

  require = [
    # boot (is it the right place ?)
    (import ../system/kernel.nix)
    (import ../boot/boot-stage-2.nix)
    (import ../installer/grub.nix)

    # system
    (import ../system/system-options.nix)
    (import ../system/activate-configuration.nix)
    (import ../upstart-jobs/default.nix)

    (import ../upstart-jobs/acpid.nix) # ACPI daemon

    (import ../system/unix-odbc-drivers.nix)

    (import ../upstart-jobs/klogd.nix)

    (import ../upstart-jobs/lvm.nix) # Makes LVM logical volumes available.

    (import ../upstart-jobs/swraid.nix) # Activate software RAID arrays.

    (import ../upstart-jobs/filesystems.nix) # Mount file systems.

    (import ../upstart-jobs/swap.nix)
    (import ../upstart-jobs/network-interfaces.nix)
    (import ../upstart-jobs/nscd.nix) # Name service cache daemon.

    # security
    (import ../system/sudo.nix)

    # i18n
    (import ../system/i18n.nix)

    # environment
    (import ../etc/default.nix)

    (import ../system/nixos-environment.nix)

    # users
    (import ../system/users-groups.nix)

    # newtworking
    (import ../upstart-jobs/dhclient.nix)

    # hardware
    (import ../upstart-jobs/pcmcia.nix)

    # security
    (import ../system/nixos-security.nix)

    # services
    (import ../upstart-jobs/avahi-daemon.nix)
    (import ../upstart-jobs/atd.nix)
    (import ../upstart-jobs/dbus.nix)
    (import ../upstart-jobs/hal.nix)
    (import ../upstart-jobs/gpm.nix)
    (import ../upstart-jobs/nagios/default.nix)
    (import ../upstart-jobs/xserver/default.nix)
    (import ../upstart-jobs/zabbix-agent.nix)
    (import ../upstart-jobs/zabbix-server.nix)
    (import ../upstart-jobs/disnix.nix)
    (import ../upstart-jobs/cron.nix)
    (import ../upstart-jobs/fcron.nix)
    (import ../upstart-jobs/cron/locate.nix)
    (import ../upstart-jobs/manual.nix)
    (import ../upstart-jobs/rogue.nix)
    (import ../upstart-jobs/guest-users.nix)
    (import ../upstart-jobs/pulseaudio.nix)
    (import ../upstart-jobs/kbd.nix)
    (import ../upstart-jobs/gw6c.nix) # Gateway6
    (import ../upstart-jobs/syslogd.nix)
    (import ../upstart-jobs/dhcpd.nix)
    (import ../upstart-jobs/sshd.nix)
    (import ../upstart-jobs/lshd.nix) # GNU lshd SSH2 deamon (TODO: does neither start nor generate seed file ?)
    (import ../upstart-jobs/ntpd.nix)
    (import ../upstart-jobs/portmap.nix)
    (import ../upstart-jobs/bitlbee.nix)
    (import ../upstart-jobs/gnunet.nix)
    (import ../upstart-jobs/ejabberd.nix) # untested, dosen't compile on x86_64-linux
    (import ../upstart-jobs/jboss.nix)
    (import ../upstart-jobs/tomcat.nix) # untested, too lazy to get that jdk
    (import ../upstart-jobs/httpd.nix) # Apache httpd (probably this can be removed ?)
    (import ../upstart-jobs/apache-httpd) # Apache httpd (new style).
    (import ../upstart-jobs/vsftpd.nix)
    (import ../upstart-jobs/cupsd.nix) # CUPS printing daemon
    (import ../upstart-jobs/udev.nix) # The udev daemon creates devices nodes and runs programs when hardware events occur.
    (import ../upstart-jobs/samba.nix) # TODO: doesn't start here (?)
    (import ../upstart-jobs/ircd-hybrid.nix) # TODO: doesn't compile on x86_64-linux, can't test
    (import ../upstart-jobs/xfs.nix) # FIXME (assertion)
    (import ../upstart-jobs/mysql.nix)
    (import ../upstart-jobs/postgresql.nix)
    (import ../upstart-jobs/openfire.nix) # FIXME (assertion)
    (import ../upstart-jobs/postfix.nix)
    (import ../upstart-jobs/dovecot.nix)
    (import ../upstart-jobs/bind.nix)

    (import ../upstart-jobs/mingetty.nix) # The terminals on ttyX.
    (import ../upstart-jobs/tty-backgrounds.nix) #FIXME (assertion)

    # nix
    (import ../upstart-jobs/nix.nix) # nix options and daemon
    (import ../system/nixos-installer.nix)


    #users
    (import ../upstart-jobs/ldap)



    # fonts
    (import ../system/fonts.nix)

    # sound
    (import ../upstart-jobs/alsa.nix)
  ];
}
