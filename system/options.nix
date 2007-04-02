{pkgs}:

[


  {
    name = ["time" "timeZone"];
    default = "CET";
    example = "America/New_York";
    description = "The time zone used when displaying times and dates.";
  }

  
  {
    name = ["boot" "autoDetectRootDevice"];
    default = false;
    description = "
      Whether to find the root device automatically by searching for a
      device with the right label.  If this option is off, then a root
      file system must be specified using <option>fileSystems</option>.
    ";
  }


  {
    name = ["boot" "readOnlyRoot"];
    default = false;
    description = "
      Whether the root device is read-only.  This should be set when
      booting from CD-ROM.
    ";
  }


  {
    name = ["boot" "rootLabel"];
    description = "
      When auto-detecting the root device (see
      <option>boot.autoDetectRootDevice</option>), this option
      specifies the label of the root device.  Right now, this is
      merely a file name that should exist in the root directory of
      the file system.  It is used to find the boot CD-ROM.
    ";
  }


  {
    name = ["boot" "grubDevice"];
    default = "";
    example = "/dev/hda";
    description = "
      The device on which the boot loader, Grub, will be installed.
      If empty, Grub won't be installed and it's your responsibility
      to make the system bootable.
    ";
  }


  {
    name = ["boot" "kernelParams"];
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
  }


  {
    name = ["boot" "extraKernelParams"];
    default = [
    ];
    example = [
      "debugtrace"
    ];
    description = "
      Additional user-defined kernel parameters.
    ";
  }


  {
    name = ["boot" "hardwareScan"];
    default = true;
    description = "
      Whether to try to load kernel modules for all detected hardware.
      Usually this does a good job of providing you with the modules
      you need, but sometimes it can crash the system or cause other
      nasty effects.  If the hardware scan is turned on, it can be
      disabled at boot time by adding the <literal>safemode</literal>
      parameter to the kernel command line.
    ";
  }


  {
    name = ["boot" "kernelModules"];
    default = [];
    description = "
      The set of kernel modules to be loaded in the second stage of
      the boot process.  That is, these modules are not included in
      the initial ramdisk, so they'd better not be required for
      mounting the root file system.  Add them to
      <option>boot.initrd.extraKernelModules</option> if they are.
    ";
  }


  {
    name = ["boot" "initrd" "kernelModules"];
    default = [
      "ahci"
      "ata_piix"
      "pata_marvell"
      "sd_mod"
      "sr_mod"
      "ide-cd"
      "ide-disk"
      "ide-generic"
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
  }


  {
    name = ["boot" "initrd" "extraKernelModules"];
    default = [];
    description = "
      Additional kernel modules for the initial ramdisk.  These are
      loaded before the modules listed in
      <option>boot.initrd.kernelModules</option>, so they take
      precedence.
    ";
  }


  {
    name = ["boot" "initrd" "enableSplashScreen"];
    default = true;
    description = "
      Whether to show a nice splash screen while booting.
    ";
  }


  {
    name = ["boot" "copyKernels"];
    default = false;
    description = "
      Whether the Grub menu builder should copy kernels and initial
      ramdisks to /boot.  This is necessary when /nix is on a
      different file system than /.
    ";
  }


  {
    name = ["boot" "localCommands"];
    default = "";
    example = "text=anything; echo You can put $text here.";
    description = "
      Shell commands to be executed just before Upstart is started.
    ";
  }


  { 
    name = ["networking" "hostName"];
    default = "nixos";
    description = "The name of the machine.";
  }


  {
    name = ["networking" "useDHCP"];
    default = true;
    description = "
      Whether to use DHCP to obtain an IP adress and other
      configuration for all network interfaces that are not manually
      configured.
    ";
  }

  
  {
    name = ["networking" "interfaces"];
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
  }

  
  {
    name = ["networking" "defaultGateway"];
    default = "";
    example = "131.211.84.1";
    description = "
      The default gateway.  It can be left empty if it is auto-detected through DHCP.
    ";
  }

  
  {
    name = ["networking" "nameservers"];
    default = [];
    example = ["130.161.158.4" "130.161.33.17"];
    description = "
      The list of nameservers.  It can be left empty if it is auto-detected through DHCP.
    ";
  }

  
  {
    name = ["networking" "enableIntel2200BGFirmware"];
    default = false;
    description = "
      Turn on this option if you want firmware for the Intel
      PRO/Wireless 2200BG to be loaded automatically.  This is
      required if you want to use this device.  Intel requires you to
      accept the license for this firmware, see
      <link xlink:href='http://ipw2200.sourceforge.net/firmware.php?fid=7'/>.
    ";
  }

  
  {
    name = ["fileSystems"];
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
    ";
  }


  {
    name = ["swapDevices"];
    default = [];
    example = [
      {device="/dev/hda7";}
      {device="/var/swapfile";}
      {label="bigswap";}
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
  }


  {
    name = ["services" "extraJobs"];
    default = [];
    description = "
      Additional Upstart jobs.
    ";
  }

  
  {
    name = ["services" "syslogd" "tty"];
    default = 10;
    description = "
      The tty device on which syslogd will print important log
      messages.
    ";
  }

      
  {
    name = ["services" "ttyBackgrounds" "enable"];
    default = true;
    description = "
      Whether to enable graphical backgrounds for the virtual consoles.
    ";
  }

      
  {
    name = ["services" "ttyBackgrounds" "defaultTheme"];
    default = pkgs.fetchurl {
      url = http://www.bootsplash.de/files/themes/Theme-BabyTux.tar.bz2;
      md5 = "a6d89d1c1cff3b6a08e2f526f2eab4e0";
    };
    description = "
      The default theme for the virtual consoles.  Themes can be found
      at <link xlink:href='http://www.bootsplash.de/' />.
    ";
  }

      
  {
    name = ["services" "ttyBackgrounds" "defaultSpecificThemes"];
    default = [
      { tty = 6;
        theme = pkgs.fetchurl { # Yeah!
          url = http://www.bootsplash.de/files/themes/Theme-Pativo.tar.bz2;
          md5 = "9e13beaaadf88d43a5293e7ab757d569";
        };
      }
      { tty = 10;
        theme = pkgs.fetchurl {
          url = http://www.bootsplash.de/files/themes/Theme-GNU.tar.bz2;
          md5 = "61969309d23c631e57b0a311102ef034";
        };
      }
    ];
    description = "
      This option sets specific themes for virtual consoles.  If you
      just want to set themes for additional consoles, use
      <option>services.ttyBackgrounds.specificThemes</option>.
    ";
  }

      
  {
    name = ["services" "ttyBackgrounds" "specificThemes"];
    default = [
    ];
    description = "
      This option allows you to set specific themes for virtual
      consoles.
    ";
  }

      
  {
    name = ["services" "mingetty" "ttys"];
    default = [1 2 3 4 5 6];
    description = "
      The list of tty (virtual console) devices on which to start a
      login prompt.
    ";
  }


  /*      
  {
    name = ["services" "mingetty" "waitOnMounts"];
    default = false;
    description = "
      Whether the login prompts on the virtual consoles will be
      started before or after all file systems have been mounted.  By
      default we don't wait, but if for example your /home is on a
      separate partition, you may want to turn this on.
    ";
  }
  */

  
  {
    name = ["services" "dhcpd" "enable"];
    default = false;
    description = "
      Whether to enable the DHCP server.
    ";
  }

  
  {
    name = ["services" "dhcpd" "configFile"];
    description = "
      The path of the DHCP server configuration file.
    ";
  }

  
  {
    name = ["services" "dhcpd" "interfaces"];
    default = ["eth0"];
    description = "
      The interfaces on which the DHCP server should listen.
    ";
  }

  
  {
    name = ["services" "sshd" "enable"];
    default = false;
    description = "
      Whether to enable the Secure Shell daemon, which allows secure
      remote logins.
    ";
  }

  
  {
    name = ["services" "sshd" "forwardX11"];
    default = true;
    description = "
      Whether to enable sshd to forward X11 connections.
    ";
  }

  
  {
    name = ["services" "sshd" "allowSFTP"];
    default = true;
    description = "
      Whether to enable the SFTP subsystem in the SSH daemon.  This
      enables the use of commands such as <command>sftp</command> and
      <command>sshfs</command>.
    ";
  }

  
  {
    name = ["services" "ntp" "enable"];
    default = true;
    description = "
      Whether to synchronise your machine's time using the NTP
      protocol.
    ";
  }

  
  {
    name = ["services" "ntp" "servers"];
    default = [
      "0.pool.ntp.org"
      "1.pool.ntp.org"
      "2.pool.ntp.org"
    ];
    description = "
      The set of NTP servers from which to synchronise.
    ";
  }

  
  {
    name = ["services" "xserver" "enable"];
    default = false;
    description = "
      Whether to enable the X server.
    ";
  }

  
  {
    name = ["services" "xserver" "resolutions"];
    default = [{x = 1024; y = 768;} {x = 800; y = 600;} {x = 640; y = 480;}];
    description = "
      The screen resolutions for the X server.  The first element is the default resolution.
    ";
  }

  
  {
    name = ["services" "xserver" "videoDriver"];
    default = "vesa";
    example = "i810";
    description = "
      The name of the video driver for your graphics card.
    ";
  }


  {
    name = ["services" "xserver" "driSupport"];
    default = false;
    description = "
      Whether to enable accelerated OpenGL rendering through the
      Direct Rendering Interface (DRI).
    ";
  }

  
  {
    name = ["services" "xserver" "sessionType"];
    default = "gnome";
    example = "xterm";
    description = "
      The kind of session to start after login.  Current possibilies
      are <literal>kde</literal> (which starts KDE),
      <literal>gnome</literal> (which starts
      <command>gnome-terminal</command>) and <literal>xterm</literal>
      (which starts <command>xterm</command>).
    ";
  }

  
  {
    name = ["services" "xserver" "windowManager"];
    default = "";
    description = "
      This option selects the window manager.  Available values are
      <literal>twm</literal> (extremely primitive),
      <literal>metacity</literal>, and <literal>compiz</literal>.  If
      left empty, the <option>sessionType</option> determines the
      window manager, e.g., Metacity for Gnome, and
      <command>kwm</command> for KDE.
    ";
  }

  
  {
    name = ["services" "xserver" "sessionStarter"];
    example = "${pkgs.xterm}/bin/xterm -ls";
    description = "
      The command executed after login and after the window manager
      has been started.  Used if
      <option>services.xserver.sessionType</option> is not empty.
    ";
  }

  
  {
    name = ["services" "xserver" "startSSHAgent"];
    default = true;
    description = "
      Whether to start the SSH agent when you log in.  The SSH agent
      remembers private keys for you so that you don't have to type in
      passphrases every time you make an SSH connection.  Use
      <command>ssh-add</command> to add a key to the agent.
    ";
  }

  
  {
    name = ["services" "httpd" "enable"];
    default = false;
    description = "
      Whether to enable the Apache httpd server.
    ";
  }


  {
    name = ["services" "httpd" "user"];
    default = "wwwrun";
    description = "
      User account under which httpd runs.  The account is created
      automatically if it doesn't exist.
    ";
  }

  
  {
    name = ["services" "httpd" "group"];
    default = "wwwrun";
    description = "
      Group under which httpd runs.  The account is created
      automatically if it doesn't exist.
    ";
  }

  
  {
    name = ["services" "httpd" "hostName"];
    default = "localhost";
    description = "
      Canonical hostname for the server.
    ";
  }

  
  {
    name = ["services" "httpd" "httpPort"];
    default = 80;
    description = "
      Port for unencrypted HTTP requests.
    ";
  }

  
  {
    name = ["services" "httpd" "httpsPort"];
    default = 443;
    description = "
      Port for encrypted HTTP requests.
    ";
  }

  
  {
    name = ["services" "httpd" "adminAddr"];
    example = "admin@example.org";
    description = "
      E-mail address of the server administrator.
    ";
  }

  
  {
    name = ["services" "httpd" "logDir"];
    default = "/var/log/httpd";
    description = "
      Directory for Apache's log files.  It is created automatically.
    ";
  }


  {
    name = ["services" "httpd" "stateDir"];
    default = "/var/run/httpd";
    description = "
      Directory for Apache's transient runtime state (such as PID
      files).  It is created automatically.  Note that the default,
      <filename>/var/run/httpd</filename>, is deleted at boot time.
    ";
  }

  
  {
    name = ["services" "httpd" "subservices" "subversion" "enable"];
    default = false;
    description = "
      Whether to enable the Subversion subservice in the webserver.
    ";
  }

  
  {
    name = ["services" "httpd" "subservices" "subversion" "notificationSender"];
    example = "svn-server@example.org";
    description = "
      The email address used in the Sender field of commit
      notification messages sent by the Subversion subservice.
    ";
  }

  
  {
    name = ["services" "httpd" "subservices" "subversion" "userCreationDomain"];
    example = "example.org";
    description = "
      The domain from which user creation is allowed.  A client can
      only create a new user account if its IP address resolves to
      this domain.
    ";
  }

  
  {
    name = ["services" "httpd" "subservices" "subversion" "autoVersioning"];
    default = false;
    description = "
      Whether you want the Subversion subservice to support
      auto-versioning, which enables Subversion repositories to be
      mounted as read/writable file systems on operating systems that
      support WebDAV.
    ";
  }

  {
    name = ["services" "httpd" "subservices" "subversion" "organization" "name"];
    default = null;
    description = "
      Name of the organization hosting the Subversion service.
    ";
  }

  
  {
    name = ["services" "httpd" "subservices" "subversion" "organization" "url"];
    default = null;
    description = "
      URL of the website of the organization hosting the Subversion service.
    ";
  }

  
  {
    name = ["services" "httpd" "subservices" "subversion" "organization" "logo"];
    default = null;
    description = "
      Logo the organization hosting the Subversion service.
    ";
  }

  
  {
    name = ["services" "httpd" "extraSubservices" "enable"];
    default = false;
    description = "
      Whether to enable the extra subservices in the webserver.
    ";
  }

  
  {
    name = ["services" "httpd" "extraSubservices" "services"];
    default = [];
    description = "
      Extra subservices to enable in the webserver.
    ";
  }

  
  {
    name = ["installer" "nixpkgsURL"];
    default = "";
    example = http://nix.cs.uu.nl/dist/nix/nixpkgs-0.11pre7577;
    description = "
      URL of the Nixpkgs distribution to use when building the
      installation CD.
    ";
  }

  
  {
    name = ["nix" "maxJobs"];
    default = 1;
    example = 2;
    description = "
      This option defines the maximum number of jobs that Nix will try
      to build in parallel.  The default is 1.  You should generally
      set it to the number of CPUs in your system (e.g., 2 on a Athlon
      64 X2).
    ";
  }

  
  {
    name = ["security" "setuidPrograms"];
    default = ["passwd" "su" "crontab" "ping" "ping6"];
    description = "
      Only the programs listed here will be made setuid root (through
      a wrapper program).
    ";
  }

  
  {
    name = ["users" "ldap" "enable"];
    default = false;
    description = "
      Whether to enable authentication against an LDAP server.
    ";
  }

  
  {
    name = ["users" "ldap" "server"];
    example = "ldap://ldap.example.org/";
    description = "
      The URL of the LDAP server.
    ";
  }

  
  {
    name = ["users" "ldap" "base"];
    example = "dc=example,dc=org";
    description = "
      The distinguished name of the search base.
    ";
  }

  
  {
    name = ["users" "ldap" "useTLS"];
    default = false;
    description = "
      If enabled, use TLS (encryption) over an LDAP (port 389)
      connection.  The alternative is to specify an LDAPS server (port
      636) in <option>users.ldap.server</option> or to forego
      security.
    ";
  }


  {
    name = ["fonts" "enableFontConfig"];
    default = true;
    description = "
      If enabled, a fontconfig configuration file will be built
      pointing to a set of default fonts.  If you don't care about
      running X11 applications or any other program that uses
      fontconfig, you can turn this option off and prevent a
      dependency on all those fonts.
    ";
  }

  
  {
    name = ["sound" "enable"];
    default = true;
    description = "
      Whether to enable ALSA sound.
    ";
  }

  
]
