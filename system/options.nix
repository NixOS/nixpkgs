{pkgs, mkOption}:

{


  time = {

    timeZone = mkOption {
      default = "CET";
      example = "America/New_York";
      description = "The time zone used when displaying times and dates.";
    };

  };

  
  boot = {

    autoDetectRootDevice = mkOption {
      default = false;
      description = "
        Whether to find the root device automatically by searching for a
        device with the right label.  If this option is off, then a root
        file system must be specified using <option>fileSystems</option>.
      ";
    };

    isLiveCD = mkOption {
      default = false;
      description = "
        If set to true, the root device will be mounted read-only and
        a ramdisk will be mounted on top of it using unionfs to
        provide a writable root.  This is used for the NixOS
        Live-CD/DVD.
      ";
    };

    rootLabel = mkOption {
      description = "
        When auto-detecting the root device (see
        <option>boot.autoDetectRootDevice</option>), this option
        specifies the label of the root device.  Right now, this is
        merely a file name that should exist in the root directory of
        the file system.  It is used to find the boot CD-ROM.
      ";
    };

    grubDevice = mkOption {
      default = "";
      example = "/dev/hda";
      description = "
        The device on which the boot loader, Grub, will be installed.
        If empty, Grub won't be installed and it's your responsibility
        to make the system bootable.
      ";
    };

    bootMount = mkOption {
      default = "";
      example = "(hd0,0)";
      description = "
        If the system partition may be wiped on reinstall, it is better
        to have /boot on a small partition. To do it, we need to explain
        to GRUB where the kernels live. Specify the partition here (in 
        GRUB notation.
      ";
    };

    kernel = mkOption {
      default = pkgs: pkgs.kernel;
      description = "
        Function that takes package collection and returns kernel 
        package. Do not collect old generations after changing it
        until you get to boot successfully. In principle, you can 
        specify a kernel that will build, but not boot.
      ";
    };

    configurationName = mkOption {
      default = "";
      example = "Stable 2.6.21";
      description = "
        Grub entry name instead of default.
      ";
    };

    kernelParams = mkOption {
      default = [
        "selinux=0"
        "apm=on"
        "acpi=on"
        "vga=0x317"
        "console=tty1"
        "splash=verbose"
      ];
      description = "
        The kernel parameters.  If you want to add additional
        parameters, it's best to set
        <option>boot.extraKernelParams</option>.
      ";
    };

    extraKernelParams = mkOption {
      default = [
      ];
      example = [
        "debugtrace"
      ];
      description = "
        Additional user-defined kernel parameters.
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

    extraModulePackages = mkOption {
      default = [];
      example = [pkgs.aufs pkgs.nvidiaDrivers];
      description = ''
        A list of additional packages supplying kernel modules.
      '';
    };

    kernelModules = mkOption {
      default = [];
      description = "
        The set of kernel modules to be loaded in the second stage of
        the boot process.  That is, these modules are not included in
        the initial ramdisk, so they'd better not be required for
        mounting the root file system.  Add them to
        <option>boot.initrd.extraKernelModules</option> if they are.
      ";
    };

    initrd = {

      kernelModules = mkOption {
        default = [
          # Note: most of these (especially the SATA/PATA modules)
          # shouldn't be included by default since nixos-hardware-scan
          # detects them, but I'm keeping them for now for backwards
          # compatibility.
          
          # Some SATA/PATA stuff.        
          "ahci"
          "sata_nv"
          "sata_via"
          "sata_sis"
          "sata_uli"
          "ata_piix"
          "pata_marvell"
          # Standard SCSI stuff.
          "sd_mod"
          "sr_mod"
          # Standard IDE stuff.
          "ide_cd"
          "ide_disk"
          "ide_generic"
          # Filesystems.
          "ext3"
          # Support USB keyboards, in case the boot fails and we only have
          # a USB keyboard.
          "ehci_hcd"
          "ohci_hcd"
          "usbhid"
        ];
        description = "
          The set of kernel modules in the initial ramdisk used during the
          boot process.  This set must include all modules necessary for
          mounting the root device.  That is, it should include modules
          for the physical device (e.g., SCSI drivers) and for the file
          system (e.g., ext3).  The set specified here is automatically
          closed under the module dependency relation, i.e., all
          dependencies of the modules list here are included
          automatically.  If you want to add additional
          modules, it's best to set
          <option>boot.initrd.extraKernelModules</option>.
        ";
      };

      extraKernelModules = mkOption {
        default = [];
        description = "
          Additional kernel modules for the initial ramdisk.  These are
          loaded before the modules listed in
          <option>boot.initrd.kernelModules</option>, so they take
          precedence.
        ";
      };

      lvm = mkOption {
        default = false;
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

    extraGrubEntries = mkOption {
      default = "";
      example = "
        title Windows
          chainloader (hd0,1)+1
      ";
      description = "
        Any additional entries you want added to the Grub boot menu.
      ";
    };

    grubSplashImage = mkOption {
      default = pkgs.fetchurl {
        url = http://www.gnome-look.org/CONTENT/content-files/36909-soft-tux.xpm.gz;
        sha256 = "14kqdx2lfqvh40h6fjjzqgff1mwk74dmbjvmqphi6azzra7z8d59";
      };
      example = null;
      description = "
        Background image used for Grub.  It must be a 640x480,
        14-colour image in XPM format, optionally compressed with
        <command>gzip</command> or <command>bzip2</command>.  Set to
        <literal>null</literal> to run Grub in text mode.
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

    configurationLimit = mkOption {
      default = 100;
      example = 120;
      description = "
        Maximum of configurations in boot menu. GRUB has problems when
	there are too many entries.
      ";
    };

  };


  # Hm, this sounds like a catch-all...
  hardware = {

    enableGo7007 = mkOption {
      default = false;
      description = ''
        Enable this option to get support for the WIS GO7007SB
        multi-format video encoder, which is used in a number of
        devices such as the Plextor ConvertX TV402U USB TV device.
      '';
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

    extraHosts = mkOption {
      default = "";
      example = "192.168.0.1 lanlocalhost";
      description = "Pasted verbatim into /etc/hosts.";
    };

    useDHCP = mkOption {
      default = true;
      description = "
        Whether to use DHCP to obtain an IP adress and other
        configuration for all network interfaces that are not manually
        configured.
      ";
    };

    interfaces = mkOption {
      default = [];
      example = [
        { name = "eth0";
          ipAddress = "131.211.84.78";
          subnetMask = "255.255.255.128";
        }
      ];
      description = "
        The configuration for each network interface.  If
        <option>networking.useDHCP</option> is true, then each interface
        not listed here will be configured using DHCP.
      ";
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

    enableIntel2200BGFirmware = mkOption {
      default = false;
      description = "
        Turn on this option if you want firmware for the Intel
        PRO/Wireless 2200BG to be loaded automatically.  This is
        required if you want to use this device.  Intel requires you to
        accept the license for this firmware, see
        <link xlink:href='http://ipw2200.sourceforge.net/firmware.php?fid=7'/>.
      ";
    };

    enableIntel3945ABGFirmware = mkOption {
      default = false;
      description = "
        This option enables automatic loading of the firmware for the Intel
        PRO/Wireless 3945ABG.
      ";
    };

    enableIntel4965AGNFirmware = mkOption {
      default = false;
      description = "
        This option enables automatic loading of the firmware for the Intel
        PRO/Wireless 4965AGN.
      ";
    };

    enableZydasZD1211Firmware = mkOption {
      default = false;
      description = "
        This option enables automatic loading of the firmware for the Zydas
        ZyDAS ZD1211(b) 802.11a/b/g USB WLAN chip.
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
      the root directory (<literal>mountPoint = \"/\"</literal>) if
      <literal>boot.autoDetectRootDevice</literal> is not set.  Each
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


  services = {


    extraJobs = mkOption {
      default = [];
      description = "
        Additional Upstart jobs.
      ";
    };

  
    syslogd = {

      tty = mkOption {
        default = 10;
        description = "
          The tty device on which syslogd will print important log
          messages.
        ";
      };
    
    };


    cron = {

      systemCronJobs = mkOption {
        default = [];
        example = [
          "* * * * *  test   ls -l / > /tmp/cronout 2>&1"
          "* * * * *  eelco  echo Hello World > /home/eelco/cronout"
        ];
        description = ''
          A list of Cron jobs to be appended to the system-wide
          crontab.  See the manual page for crontab for the expected
          format.
        '';
      };

    };


    locate = {

      enable = mkOption {
        default = false;
        example = true;
        description = ''
          If enabled, NixOS will periodically update the database of
          files used by the <command>locate</command> command.
        '';
      };

      period = mkOption {
        default = "15 02 * * *";
        description = ''
          This option defines (in the format used by cron) when the
          locate database is updated.
          The default is to update at 02:15 (at night) every day.
        '';
      };

    };


    ttyBackgrounds = {

      enable = mkOption {
        default = true;
        description = "
          Whether to enable graphical backgrounds for the virtual consoles.
        ";
      };

      defaultTheme = mkOption {
        default = pkgs.fetchurl {
          #url = http://www.bootsplash.de/files/themes/Theme-BabyTux.tar.bz2;
          url = http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/Theme-BabyTux.tar.bz2;
          md5 = "a6d89d1c1cff3b6a08e2f526f2eab4e0";
        };
        description = "
          The default theme for the virtual consoles.  Themes can be found
          at <link xlink:href='http://www.bootsplash.de/' />.
        ";
      };

      defaultSpecificThemes = mkOption {
        default = [
          /*
          { tty = 6;
            theme = pkgs.fetchurl { # Yeah!
              url = http://www.bootsplash.de/files/themes/Theme-Pativo.tar.bz2;
              md5 = "9e13beaaadf88d43a5293e7ab757d569";
            };
          }
          */
          { tty = 10;
            theme = pkgs.fetchurl {
              #url = http://www.bootsplash.de/files/themes/Theme-GNU.tar.bz2;
              url = http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/Theme-GNU.tar.bz2;
              md5 = "61969309d23c631e57b0a311102ef034";
            };
          }
        ];
        description = "
          This option sets specific themes for virtual consoles.  If you
          just want to set themes for additional consoles, use
          <option>services.ttyBackgrounds.specificThemes</option>.
        ";
      };

      specificThemes = mkOption {
        default = [
        ];
        description = "
          This option allows you to set specific themes for virtual
          consoles.
        ";
      };

    };


    mingetty = {

      ttys = mkOption {
        default = [1 2 3 4 5 6];
        description = "
          The list of tty (virtual console) devices on which to start a
          login prompt.
        ";
      };

      waitOnMounts = mkOption {
        default = false;
        description = "
          Whether the login prompts on the virtual consoles will be
          started before or after all file systems have been mounted.  By
          default we don't wait, but if for example your /home is on a
          separate partition, you may want to turn this on.
        ";
      };

      greetingLine = mkOption {
        default = ''<<< Welcome to NixOS (\m) - Kernel \r (\l) >>>'';
        description = "
          Welcome line printed by mingetty.
        ";
      };

      helpLine = mkOption {
        default = "";
        description = "
          Help line printed by mingetty below the welcome line.
          Used by the installation CD to give some hints on
          how to proceed.
        ";
      };

    };


    dhcpd = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable the DHCP server.
        ";
      };

      extraConfig = mkOption {
        default = "";
        example = "
          option subnet-mask 255.255.255.0;
          option broadcast-address 192.168.1.255;
          option routers 192.168.1.5;
          option domain-name-servers 130.161.158.4, 130.161.33.17, 130.161.180.1;
          option domain-name \"example.org\";
          subnet 192.168.1.0 netmask 255.255.255.0 {
            range 192.168.1.100 192.168.1.200;
          }
        ";
        description = "
          Extra text to be appended to the DHCP server configuration
          file.  Currently, you almost certainly need to specify
          something here, such as the options specifying the subnet
          mask, DNS servers, etc.
        ";
      };

      configFile = mkOption {
        default = null;
        description = "
          The path of the DHCP server configuration file.  If no file
          is specified, a file is generated using the other options.
        ";
      };

      interfaces = mkOption {
        default = ["eth0"];
        description = "
          The interfaces on which the DHCP server should listen.
        ";
      };

      machines = mkOption {
        default = [];
        example = [
          { hostName = "foo";
            ethernetAddress = "00:16:76:9a:32:1d";
            ipAddress = "192.168.1.10";
          }
          { hostName = "bar";
            ethernetAddress = "00:19:d1:1d:c4:9a";
            ipAddress = "192.168.1.11";
          }
        ];
        description = "
          A list mapping ethernet addresses to IP addresses for the
          DHCP server.
        ";
      };

    };


    sshd = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable the Secure Shell daemon, which allows secure
          remote logins.
        ";
      };

      forwardX11 = mkOption {
        default = true;
        description = "
          Whether to enable sshd to forward X11 connections.
        ";
      };

      allowSFTP = mkOption {
        default = true;
        description = "
          Whether to enable the SFTP subsystem in the SSH daemon.  This
          enables the use of commands such as <command>sftp</command> and
          <command>sshfs</command>.
        ";
      };

    };


    ntp = {

      enable = mkOption {
        default = true;
        description = "
          Whether to synchronise your machine's time using the NTP
          protocol.
        ";
      };

      servers = mkOption {
        default = [
          "0.pool.ntp.org"
          "1.pool.ntp.org"
          "2.pool.ntp.org"
        ];
        description = "
          The set of NTP servers from which to synchronise.
        ";
      };

    };

    bitlbee = {

      enable = mkOption {
        default = false;
        description = ''
          Whether the run the BitlBee IRC to other chat network gateway.
          Running it allows you to access the MSN, Jabber, Yahoo! and ICQ chat
          networks via an IRC client.
        '';
      };

      interface = mkOption {
        default = "127.0.0.1";
        description = ''
          The interface the BitlBee deamon will be listening to.  If `127.0.0.1',
          only clients on the local host can connect to it; if `0.0.0.0', clients
          can access it from any network interface.
        '';
      };

      portNumber = mkOption {
        default = "6667";
        description = ''
          Number of the port BitlBee will be listening to.
        '';
      };

    };

    xserver = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable the X server.
        ";
      };

      autorun = mkOption {
        default = true;
	description = "
	  Switch to false to create upstart-job and configuration, 
	  but not run it automatically
	";
      };

      exportConfiguration = mkOption {
        default = false;
	description = "
	  Create /etc/X11/xorg.conf and a file with environment
	  variables
	";
      };

      tcpEnable = mkOption {
        default = false;
        description = "
          Whether to enable TCP socket for the X server.
        ";
      };

      resolutions = mkOption {
        default = [{x = 1024; y = 768;} {x = 800; y = 600;} {x = 640; y = 480;}];
        description = "
          The screen resolutions for the X server.  The first element is the default resolution.
        ";
      };

      videoDriver = mkOption {
        default = "vesa";
        example = "i810";
        description = "
          The name of the video driver for your graphics card.
        ";
      };

      driSupport = mkOption {
        default = false;
        description = "
          Whether to enable accelerated OpenGL rendering through the
          Direct Rendering Interface (DRI).
        ";
      };

      sessionType = mkOption {
        default = "gnome";
        example = "xterm";
        description = "
          The kind of session to start after login.  Current possibilies
          are <literal>kde</literal> (which starts KDE),
          <literal>gnome</literal> (which starts
          <command>gnome-terminal</command>) and <literal>xterm</literal>
          (which starts <command>xterm</command>).
        ";
      };

      windowManager = mkOption {
        default = "";
        description = "
          This option selects the window manager.  Available values are
          <literal>twm</literal> (extremely primitive),
          <literal>metacity</literal>, <literal>xmonad</literal>
          and <literal>compiz</literal>.  If
          left empty, the <option>sessionType</option> determines the
          window manager, e.g., Metacity for Gnome, and
          <command>kwm</command> for KDE.
        ";
      };

      renderingFlag = mkOption {
        default = "";
        example = "--indirect-rendering";
        description = "
          Possibly pass --indierct-rendering to Compiz.
        ";
      };

      sessionStarter = mkOption {
        example = "${pkgs.xterm}/bin/xterm -ls";
        description = "
          The command executed after login and after the window manager
          has been started.  Used if
          <option>services.xserver.sessionType</option> is empty.
        ";
      };

      startSSHAgent = mkOption {
        default = true;
        description = "
          Whether to start the SSH agent when you log in.  The SSH agent
          remembers private keys for you so that you don't have to type in
          passphrases every time you make an SSH connection.  Use
          <command>ssh-add</command> to add a key to the agent.
        ";
      };

      slim = {

        theme = mkOption {
          default = null;
          example = pkgs.fetchurl {
            url = http://download.berlios.de/slim/slim-wave.tar.gz;
            sha256 = "0ndr419i5myzcylvxb89m9grl2xyq6fbnyc3lkd711mzlmnnfxdy";
          };
          description = "
            The theme for the SLiM login manager.  If not specified, SLiM's
            default theme is used.  See <link
            xlink:href='http://slim.berlios.de/themes01.php'/> for a
            collection of themes.
          ";
        };

      };

      isClone = mkOption {
        default = true;
        example = false;
        description = "
          Whether to enable the X server clone mode for dual-head.
        ";
      };

      isSynaptics = mkOption {
        default = false;
        example = true;
        description = "
          Whether to replace mouse with touchpad.
        ";
      };

      devSynaptics = mkOption {
        default = "/dev/input/event0";
        description = "
          Event device for Synaptics touchpad.
        ";
      };

      layout = mkOption {
        default = "us";
        description = "
          Keyboard layout.
        ";
      };

      xkbOptions = mkOption {
        default = "";
        example = "grp:caps_toggle, grp_led:scroll";
        description = "
          X keyboard options; layout switching goes here.
        ";
      };

      useInternalAGPGART = mkOption {
        default = "";
        example = "no";
        description = "
          Just the wrapper for an xorg.conf option.
        ";
      };

      extraDeviceConfig = mkOption {
        default = "";
        example = "VideoRAM 131072";
        description = "
          Just anything to add into Device section.
        ";
      };

      extraMonitorSettings = mkOption {
        default = "";
        example = "HorizSync 28-49";
        description = "
          Just anything to add into Monitor section.
        ";
      };

      extraDisplaySettings = mkOption {
        default = "";
        example = "Virtual 2048 2048";
        description = "
          Just anything to add into Display subsection (located in Screen section).
        ";
      };
 
      extraModules = mkOption {
        default = "";
        example = "
          SubSection \"extmod\"
          EndSubsection
        ";
        description = "
          Just anything to add into Modules section.
        ";
      };

      serverLayoutOptions = mkOption {
        default = "";
        example = "
          Option \"AIGLX\" \"true\"
        ";
        description = "
          Just anything to add into Monitor section.
        ";
      };

      defaultDepth = mkOption {
        default = 24;
        example = 8;
        description = "
          Default colour depth.
        ";
      };
      
      useXFS = mkOption {
        default = false;
	example = "unix/:7100";
	description = "
	  Way to access the X Font Server to use.
	";
      };

      tty = mkOption {
        default = 7;
        example = 9;
        description = "
          Virtual console for the X server.
        ";
      };

      display = mkOption {
        default = 0;
        example = 1;
        description = "
          Display number for the X server.
        ";
      };

    };

    ejabberd = {
      enable = mkOption {
        default = false;
	description = "Whether to enable ejabberd server";
      };
      
      user = mkOption {
        default = "nobody";
	description = "User account under which ejabberd runs.";
      };
    };

    jboss = {
      enable = mkOption {
        default = false;
	description = "Whether to enable jboss";
      };

      tempDir = mkOption {
        default = "/tmp";
	description = "Location where JBoss stores its temp files";
      };
      
      logDir = mkOption {
        default = "/var/log/jboss";
	description = "Location of the logfile directory of JBoss";
      };
      
      serverDir = mkOption {
        description = "Location of the server instance files";
	default = "/var/jboss/server";
      };
      
      deployDir = mkOption {
        description = "Location of the deployment files";
        default = "/nix/var/nix/profiles/default/server/default/deploy/";
      };
      
      libUrl = mkOption {
        default = "file:///nix/var/nix/profiles/default/server/default/lib";
	description = "Location where the shared library JARs are stored";
      };
      
      user = mkOption {
        default = "nobody";
	description = "User account under which jboss runs.";
      };
      
      useJK = mkOption {
        default = false;
	description = "Whether to use to connector to the Apache HTTP server";
      };
    };

    tomcat = {
      enable = mkOption {
        default = false;
	description = "Whether to enable Apache Tomcat";
      };
      
      baseDir = mkOption {
        default = "/var/tomcat";
	description = "Location where Tomcat stores configuration files, webapplications and logfiles";
      };
      
      user = mkOption {
        default = "nobody";
	description = "User account under which Apache Tomcat runs.";
      };      
      
      deployFrom = mkOption {
        default = "";
	description = "Location where webapplications are stored. Leave empty to use the baseDir.";
      };
    };

    httpd = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable the Apache httpd server.
        ";
      };

      experimental = mkOption {
        default = false;
        description = "
          Whether to use the new-style Apache configuration.
        ";
      };

      logPerVirtualHost = mkOption {
        default = false;
        description = "
          If enabled, each virtual host gets its own
          <filename>access_log</filename> and
          <filename>error_log</filename>, namely suffixed by the
          <option>hostName</option> of the virtual host.
        ";
      };

      user = mkOption {
        default = "wwwrun";
        description = "
          User account under which httpd runs.  The account is created
          automatically if it doesn't exist.
        ";
      };

      group = mkOption {
        default = "wwwrun";
        description = "
          Group under which httpd runs.  The account is created
          automatically if it doesn't exist.
        ";
      };

      httpsPort = mkOption {
        default = 443;
        description = "
          Port for encrypted HTTP requests.
        ";
      };

      enableSSL = mkOption {
        default = false;
        description = "
          Whether to enable SSL (https) support.
        ";
      };

      logDir = mkOption {
        default = "/var/log/httpd";
        description = "
          Directory for Apache's log files.  It is created automatically.
        ";
      };

      stateDir = mkOption {
        default = "/var/run/httpd";
        description = "
          Directory for Apache's transient runtime state (such as PID
          files).  It is created automatically.  Note that the default,
          <filename>/var/run/httpd</filename>, is deleted at boot time.
        ";
      };

      enableUserDir = mkOption {
        default = false;
        description = "
          Whether to enable serving <filename>~/public_html</filename> as
          <literal>/~<replaceable>username</replaceable></literal>.
        ";
      };

      mod_php = mkOption {
        default = false;
        description = "Whether to enable the PHP module.";
      };

      mod_jk = {
        enable = mkOption {
          default = false;
	  description = "Whether to enable the Apache Tomcat connector.";
        };
	
	applicationMappings = mkOption {
	  default = [];
	  description = "List of Java webapplications that should be mapped to the servlet container (Tomcat/JBoss)";
	};
      };

      virtualHosts = mkOption {
        default = [];
        example = [
          { hostName = "foo";
            documentRoot = "/data/webroot-foo";
          }
          { hostName = "bar";
            documentRoot = "/data/webroot-bar";
          }
        ];
        description = ''
          Specification of the virtual hosts served by Apache.  Each
          element should be an attribute set specifying the
          configuration of the virtual host.  The available options
          are the non-global options permissible for the main host.
        '';
      };

      subservices = {

        # !!! remove this
        subversion = {

          enable = mkOption {
            default = false;
            description = "
              Whether to enable the Subversion subservice in the webserver.
            ";
          };

          notificationSender = mkOption {
            default = "svn-server@example.org";
            example = "svn-server@example.org";
            description = "
              The email address used in the Sender field of commit
              notification messages sent by the Subversion subservice.
            ";
          };

          userCreationDomain = mkOption {
	    default = "example.org"; 
            example = "example.org";
            description = "
              The domain from which user creation is allowed.  A client can
              only create a new user account if its IP address resolves to
              this domain.
            ";
          };

          autoVersioning = mkOption {
            default = false;
            description = "
              Whether you want the Subversion subservice to support
              auto-versioning, which enables Subversion repositories to be
              mounted as read/writable file systems on operating systems that
              support WebDAV.
            ";
          };
	  
	  dataDir = mkOption {
	    default = "/no/such/path/exists";
	    description = "
	      Place to put SVN repository.
	    ";
	  };

          organization = {

            name = mkOption {
              default = null;
              description = "
                Name of the organization hosting the Subversion service.
              ";
            };

            url = mkOption {
              default = null;
              description = "
                URL of the website of the organization hosting the Subversion service.
              ";
            };

            logo = mkOption {
              default = null;
              description = "
                Logo the organization hosting the Subversion service.
              ";
            };

          };

        };

      };

    } // # Include the options shared between the main server and virtual hosts.
    (import ../upstart-jobs/apache-httpd/per-server-options.nix {
      inherit mkOption;
      forMainServer = true;
    });

    vsftpd = {
      enable = mkOption {
        default = false;
	description = "
	  Whether to enable the vsftpd FTP server.
	";
      };
      
      anonymousUser = mkOption {
        default = false;
	description = "
	  Whether to enable the anonymous FTP user.
	";
      };
    };
    
    printing = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable printing support through the CUPS daemon.
        ";
      };

    };


    dbus = {

      enable = mkOption {
        default = true;
        description = "
          Whether to start the D-Bus message bus daemon.  It is required
          by the HAL service.
        ";
      };

    };


    hal = {

      enable = mkOption {
        default = true;
        description = "
          Whether to start the HAL daemon.
        ";
      };

    };


    udev = {

      addFirmware = mkOption {
        default = [];
        example = ["/mnt/big-storage/firmware/"];
        description = "
          To specify firmware that is not too spread to ensure 
          a package, or have an interactive process of extraction
          and cannot be redistributed.
        ";
      };
      
      sndMode = mkOption {
        default = "0600";
	example = "0666";
	description = "
	  Permissions for /dev/snd/*, in case you have multiple 
	  logged in users or if the devices belong to root for 
	  some reason.
	";
      };
    };


    samba = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable the samba server. (to communicate with, and provide windows shares)
        ";
      };

    };


    gw6c = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable Gateway6 client (IPv6 tunnel).
        ";
      };

      autorun = mkOption {
        default = true;
	description = "
	  Switch to false to create upstart-job and configuration, 
	  but not run it automatically
	";
      };

      username = mkOption {
        default = "";
        description = "
          Your Gateway6 login name, if any.
        ";
      };

      password = mkOption {
        default = "";
        description = "
          Your Gateway6 password, if any.
        ";
      };

      server = mkOption {
        default = "anon.freenet6.net";
        example = "broker.freenet6.net";
        description = "
          Used Gateway6 server.
        ";
      };

      keepAlive = mkOption {
        default = "30";
        example = "2";
        description = "
          Gateway6 keep-alive period.
        ";
      };

      everPing = mkOption {
        default = "1000000";
        example = "2";
        description = "
          Gateway6 manual ping period.
        ";
      };

    };


    ircdHybrid = {

      enable = mkOption {
        default = false;
        description = "
          Enable IRCD.
        ";
      };

      serverName = mkOption {
        default = "hades.arpa";
        description = "
          IRCD server name.
        ";
      };

      sid = mkOption {
        default = "0NL";
        description = "
          IRCD server unique ID in a net of servers.
        ";
      };

      description = mkOption {
        default = "Hybrid-7 IRC server.";
        description = "
          IRCD server description.
        ";
      };

      rsaKey = mkOption {
        default = null;
        example = /root/certificates/irc.key;
        description = "
          IRCD server RSA key. 
        ";
      };

      certificate = mkOption {
        default = null;
        example = /root/certificates/irc.pem;
        description = "
          IRCD server SSL certificate. There are some limitations - read manual.
        ";
      };

      adminEmail = mkOption {
        default = "<bit-bucket@example.com>";
        example = "<name@domain.tld>";
        description = "
          IRCD server administrator e-mail. 
        ";
      };

      extraIPs = mkOption {
        default = [];
        example = ["127.0.0.1"];
        description = "
          Extra IP's to bind.
        ";
      };

      extraPort = mkOption {
        default = "7117";
        description = "
          Extra port to avoid filtering.
        ";
      };

    };


    xfs = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable the X Font Server.
        ";
      };

    };


    nagios = {

      enable = mkOption {
        default = false;
        description = "
          Whether to use <link
          xlink:href='http://www.nagios.org/'>Nagios</link> to monitor
          your system or network.
        ";
      };

      objectDefs = mkOption {
        description = "
          A list of Nagios object configuration files that must define
          the hosts, host groups, services and contacts for the
          network that you want Nagios to monitor.
        ";
      };

      plugins = mkOption {
        default = [pkgs.nagiosPluginsOfficial pkgs.ssmtp];
        description = "
          Packages to be added to the Nagios <envar>PATH</envar>.
          Typically used to add plugins, but can be anything.
        ";
      };

      enableWebInterface = mkOption {
        default = false;
        description = "
          Whether to enable the Nagios web interface.  You should also
          enable Apache (<option>services.httpd.enable</option>).
        ";
      };

      urlPath = mkOption {
        default = "/nagios";
        description = "
          The URL path under which the Nagios web interface appears.
          That is, you can access the Nagios web interface through
          <literal>http://<replaceable>server</replaceable>/<replaceable>urlPath</replaceable></literal>.
        ";
      };

    };

    mysql = {
      enable = mkOption {
        default = false;
	description = "
	  Whether to enable the MySQL server.
	";
      };
      
      port = mkOption {
        default = "3306";
	description = "Port of MySQL"; 
      };
      
      user = mkOption {
        default = "nobody";
	description = "User account under which MySQL runs";
      };
      
      dataDir = mkOption {
        default = "/var/mysql";
	description = "Location where MySQL stores its table files";
      };
      
      logError = mkOption {
        default = "/var/log/mysql_err.log";
	description = "Location of the MySQL error logfile";
      };
      
      pidFile = mkOption {
        default = "/var/mysql/mysql.pid";
	description = "Location of the file which stores the PID of the MySQL server";
      };
    };

    postgresql = {
      enable = mkOption {
        default = false;
	description = "
	  Whether to run PostgreSQL.
	";
      };
      port = mkOption {
        default = "5432";
	description = "
	  Port for PostgreSQL.
	";
      };
      logDir = mkOption {
        default = "/var/log/postgresql";
	description = "
	  Log directory for PostgreSQL.
	";
      };
      dataDir = mkOption {
        default = "/var/db/postgresql";
	description = "
	  Data directory for PostgreSQL.
	";
      };
      subServices = mkOption {
        default = [];
	description = "
	  Subservices list. As it is already implememnted, 
	  here is an interface...
	";
      };
      authentication = mkOption {
        default = ''
          # Generated file; do not edit!
          local all all ident sameuser
          host  all all 127.0.0.1/32 md5
          host  all all ::1/128      md5
        '';
	description = "
	  Hosts (except localhost), who you allow to connect.
	";
      };
      allowedHosts = mkOption {
        default = [];
	description = "
	  Hosts (except localhost), who you allow to connect.
	";
      };
      authMethod = mkOption {
        default = " ident sameuser ";
	description = "
	  How to authorize users. 
	  Note: ident needs absolute trust to all allowed client hosts.";
      };
    };

    openfire = {
      enable = mkOption {
        default = false;
	description = "
	  Whether to enable OpenFire XMPP server.
	";
      };
      usePostgreSQL = mkOption {
        default = true;
	description = "
	  Whether you use PostgreSQL service for your storage back-end.
	";
      };
    };

  };

  installer = {

    nixpkgsURL = mkOption {
      default = "";
      example = http://nix.cs.uu.nl/dist/nix/nixpkgs-0.11pre7577;
      description = "
        URL of the Nixpkgs distribution to use when building the
        installation CD.
      ";
    };

    manifests = mkOption {
      default = [http://nix.cs.uu.nl/dist/nix/channels-v3/nixpkgs-unstable/MANIFEST];
      example =
        [ http://nix.cs.uu.nl/dist/nix/channels-v3/nixpkgs-unstable/MANIFEST
          http://nix.cs.uu.nl/dist/nix/channels-v3/nixpkgs-stable/MANIFEST
        ];
      description = "
        URLs of manifests to be downloaded when you run
        <command>nixos-rebuild</command> to speed up builds.
      ";
    };

  };


  nix = {

    maxJobs = mkOption {
      default = 1;
      example = 2;
      description = "
        This option defines the maximum number of jobs that Nix will try
        to build in parallel.  The default is 1.  You should generally
        set it to the number of CPUs in your system (e.g., 2 on a Athlon
        64 X2).
      ";
    };

    useChroot = mkOption {
      default = false;
      example = true;
      description = "
        If set, Nix will perform builds in a chroot-environment that it
        will set up automatically for each build.  This prevents
        impurities in builds by disallowing access to dependencies
        outside of the Nix store.
      ";
    };

    extraOptions = mkOption {
      default = "";
      example = "
        gc-keep-outputs = true
        gc-keep-derivations = true
      ";
      description = "
        This option allows to append lines to nix.conf. 
      ";
    };

    distributedBuilds = mkOption {
      default = false;
      description = "
        Whether to distribute builds to the machines listed in
        <option>nix.buildMachines</option>.
      ";
    };

    buildMachines = mkOption {
      example = [
        { hostName = "voila.labs.cs.uu.nl";
          sshUser = "nix";
          sshKey = "/root/.ssh/id_buildfarm";
          system = "powerpc-darwin";
          maxJobs = 1;
        }
        { hostName = "linux64.example.org";
          sshUser = "buildfarm";
          sshKey = "/root/.ssh/id_buildfarm";
          system = "x86_64-linux";
          maxJobs = 2;
        }
      ];
      description = "
        This option lists the machines to be used if distributed
        builds are enabled (see
        <option>nix.distributedBuilds</option>).  Nix will perform
        derivations on those machines via SSh by copying the inputs to
        the Nix store on the remote machine, starting the build, then
        copying the output back to the local Nix store.  Each element
        of the list should be an attribute set containing the
        machine's host name (<varname>hostname</varname>), the user
        name to be used for the SSH connection
        (<varname>sshUser</varname>), the Nix system type
        (<varname>system</varname>, e.g.,
        <literal>\"i686-linux\"</literal>), the maximum number of jobs
        to be run in parallel on that machine
        (<varname>maxJobs</varname>), and the path to the SSH private
        key to be used to connect (<varname>sshKey</varname>).  The
        SSH private key should not have a passphrase, and the
        corresponding public key should be added to
        <filename>~<replaceable>sshUser</replaceable>/authorized_keys</filename>
        on the remote machine.
      ";
    };

  };


  security = {

    setuidPrograms = mkOption {
      default = ["passwd" "su" "crontab" "ping" "ping6"];
      description = "
        Only the programs listed here will be made setuid root (through
        a wrapper program).  It's better to set
        <option>security.extraSetuidPrograms</option>.
      ";
    };

    extraSetuidPrograms = mkOption {
      default = [];
      example = ["fusermount"];
      description = "
        This option lists additional programs that must be made setuid
        root.
      ";
    };

    seccureKeys = {
      public = mkOption {
        default = /var/elliptic-keys/public;
	description = "
	  Public key. Make it path argument, so it is copied into store and
	  hashed.
	";
      };
      private = mkOption {
        default = "/var/elliptic-keys/private";
	description = "
	  Private key. Make it string argument, so it is not copied into store.
	";
      };
    };

    sudo = {

      enable = mkOption {
        default = true;
        description = "
          Whether to enable the <command>sudo</command> command, which
          allows non-root users to execute commands as root.
        ";
      };

      configFile = mkOption {
        default = "
# WARNING: do not edit this file directly or with \"visudo\".  Instead,
# edit the source file in /etc/nixos/nixos/etc/sudoers.

# \"root\" is allowed to do anything.
root        ALL=(ALL) SETENV: ALL

# Users in the \"wheel\" group can do anything.
%wheel      ALL=(ALL) SETENV: ALL
        ";
        description = "
          This string contains the contents of the
          <filename>sudoers</filename> file.  If syntax errors are
          detected in this file, the NixOS configuration will fail to
          build. 
        ";
      };

    };

  };


  users = {

    extraUsers = mkOption {
      default = [];
      example = [
        { name = "alice";
          uid = 1234;
          description = "Alice";
          home = "/home/alice";
          createHome = true;
          group = "users";
          extraGroups = ["wheel"];
	  shell = "/bin/sh";
        }
      ];
      description = "
        Additional user accounts to be created automatically by the system.
      ";
    };

    extraGroups = mkOption {
      default = [];
      example = [
        { name = "students";
          gid = 1001;
        }
      ];
      description = "
        Additional groups to be created automatically by the system.
      ";
    };

    ldap = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable authentication against an LDAP server.
        ";
      };

      server = mkOption {
        example = "ldap://ldap.example.org/";
        description = "
          The URL of the LDAP server.
        ";
      };

      base = mkOption {
        example = "dc=example,dc=org";
        description = "
          The distinguished name of the search base.
        ";
      };

      useTLS = mkOption {
        default = false;
        description = "
          If enabled, use TLS (encryption) over an LDAP (port 389)
          connection.  The alternative is to specify an LDAPS server (port
          636) in <option>users.ldap.server</option> or to forego
          security.
        ";
      };

    };

  };


  fonts = {

    enableFontConfig = mkOption { # !!! should be enableFontconfig
      default = true;
      description = "
        If enabled, a Fontconfig configuration file will be built
        pointing to a set of default fonts.  If you don't care about
        running X11 applications or any other program that uses
        Fontconfig, you can turn this option off and prevent a
        dependency on all those fonts.
      ";
    };

    enableGhostscriptFonts = mkOption {
      default = false;
      description = "
        Whether to add the fonts provided by Ghostscript (such as
        various URW fonts and the ``Base-14'' Postscript fonts) to the
        list of system fonts, making them available to X11
        applications.
      ";
    };

    enableFontDir = mkOption {
      default = false;
      description = "
        Whether to create a directory with links to all fonts in share - 
        so user can configure vncserver script one time (I mean per-user 
        vncserver, so global service is not a good solution).
      ";
    };

    extraFonts = mkOption {
      default = pkgs: [];
      description = "
          Function, returning list of additional fonts.
      ";
    };

  };


  sound = {

    enable = mkOption {
      default = true;
      description = "
        Whether to enable ALSA sound.
      ";
    };

  };


  i18n = {

    defaultLocale = mkOption {
      default = "en_US.UTF-8";
      example = "nl_NL.UTF-8";
      description = "
        The default locale.  It determines the language for program
        messages, the format for dates and times, sort order, and so on.
        It also determines the character set, such as UTF-8.
      ";
    };

    consoleFont = mkOption {
      default = "lat9w-16";
      example = "LatArCyrHeb-16";
      description = "
        The font used for the virtual consoles.  Leave empty to use
        whatever the <command>setfont</command> program considers the
        default font.
      ";
    };

    consoleKeyMap = mkOption {
      default = "us";
      example = "fr";
      description = "
        The keyboard mapping table for the virtual consoles.
      ";
    };

  };


  environment = {

    pathsToLink = mkOption {
      default = ["/bin" "/sbin" "/share" "/man" "/info"];
      example = ["/"];
      description = "
        This allows to symlink more directories in /var/run/current-system/sw
      ";
    };

    cleanStart = mkOption {
      default = false;
      example = true;
      description = "
        There are some times when you want really small system for specific 
	purpose and do not want default package list. Setting 
	<varname>cleanStart</varname> to <literal>true</literal> allows you 
	to create a system with empty path - only extraPackages will be 
	included.
      ";
    };

    extraPackages = mkOption {
      default = pkgs: [];
      example = pkgs: [pkgs.firefox pkgs.thunderbird];
      description = "
        This option allows you to add additional packages to the system
        path.  These packages are automatically available to all users,
        and they are automatically updated every time you rebuild the
        system configuration.  (The latter is the main difference with
        installing them in the default profile,
        <filename>/nix/var/nix/profiles/default</filename>.  The value
        of this option must be a function that returns a list of
        packages.  The function will be called with the Nix Packages
        collection as its argument for convenience.
      ";
    };

    nix = mkOption {
      default = pkgs: pkgs.nixUnstable;
      example = pkgs: pkgs.nixCustomFun /root/nix.tar.gz;
      description = "
        Use non-default Nix easily. Be careful, though, not to break everything.
      ";
    };

    checkConfigurationOptions = mkOption {
      default = true;
      example = false;
      description = "
        If all configuration options must be checked. Non-existing options fail build.
      ";
    };
  };
  
  nesting = {
    children = mkOption {
      default = [];
      description = "
        Additional configurations to build.
      ";
    };
  };

}
