{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption;
  inherit (builtins) head tail;

  obsolete = what: f: name:
    if builtins ? trace then
      builtins.trace "${name}: Obsolete ${what}." f name
    else f name;

  obsoleteMerge =
    obsolete "option" pkgs.lib.mergeDefaultOption;

  # temporary modifications.
  # backward here means that expression could either be a value or a
  # function which expects to have a pkgs argument.
  optionalPkgs = name: x:
    if builtins.isFunction x
    then obsolete "notation" (name: x pkgs) name
    else x;

  backwardPkgsFunListMerge = name: list:
    pkgs.lib.concatMap (optionalPkgs name) list;

  backwardPkgsFunMerge = name: list:
    if list != [] && tail list == []
    then optionalPkgs name (head list)
    else abort "${name}: Defined at least twice.";

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
        major:minor .
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

  servicesProposal = {
    # see upstart-jobs/default.nix 
    # the option declarations can be found in the upstart-jobs/newProposal/*.nix files
    # one way to include the declarations here is adding kind of glob "*.nix"
    # file function to builtins to get all jobs
    # then the checking in upstart-jobs/default.nix can be removed again (together with passing arg optionDeclarations)
  };

  services = {

  
    syslogd = {

      tty = mkOption {
        default = 10;
        description = "
          The tty device on which syslogd will print important log
          messages.
        ";
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

      permitRootLogin = mkOption {
        default = "yes";
        description = "
          Whether the root user can login using ssh. Valid options
          are <command>yes</command>, <command>without-password</command>,
          <command>forced-commands-only</command> or
          <command>no</command>
        ";
      };

      gatewayPorts = mkOption {
        default = "no";
        description = "
           Specifies  whether  remote hosts are allowed to connect to ports forwarded for the client. See man sshd_conf.
          ";
        };
    };

    lshd = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable the GNU lshd SSH2 daemon, which allows
          secure remote login.
        '';
      };

      portNumber = mkOption {
        default = 22;
        description = ''
          The port on which to listen for connections.
        '';
      };

      interfaces = mkOption {
        default = [];
        description = ''
          List of network interfaces where listening for connections.
          When providing the empty list, `[]', lshd listens on all
          network interfaces.
        '';
        example = [ "localhost" "1.2.3.4:443" ];
      };

      hostKey = mkOption {
        default = "/etc/lsh/host-key";
        description = ''
          Path to the server's private key.  Note that this key must
          have been created, e.g., using "lsh-keygen --server |
          lsh-writekey --server", so that you can run lshd.
        '';
      };

      syslog = mkOption {
        default = true;
        description = ''Whether to enable syslog output.'';
      };

      passwordAuthentication = mkOption {
        default = true;
        description = ''Whether to enable password authentication.'';
      };

      publicKeyAuthentication = mkOption {
        default = true;
        description = ''Whether to enable public key authentication.'';
      };

      rootLogin = mkOption {
        default = false;
        description = ''Whether to enable remote root login.'';
      };

      loginShell = mkOption {
        default = null;
        description = ''
          If non-null, override the default login shell with the
          specified value.
        '';
        example = "/nix/store/xyz-bash-10.0/bin/bash10";
      };

      srpKeyExchange = mkOption {
        default = false;
        description = ''
          Whether to enable SRP key exchange and user authentication.
        '';
      };

      tcpForwarding = mkOption {
        default = true;
        description = ''Whether to enable TCP/IP forwarding.'';
      };

      x11Forwarding = mkOption {
        default = true;
        description = ''Whether to enable X11 forwarding.'';
      };

      subsystems = mkOption {
        default = [ ["sftp" "${pkgs.lsh}/sbin/sftp-server"] ];
        description = ''
          List of subsystem-path pairs, where the head of the pair
          denotes the subsystem name, and the tail denotes the path to
          an executable implementing it.
        '';
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

    portmap = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable `portmap', an ONC RPC directory service
          notably used by NFS and NIS, and which can be queried
          using the rpcinfo(1) command.
        '';
      };
    };

    bitlbee = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run the BitlBee IRC to other chat network gateway.
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
        default = 6667;
        description = ''
          Number of the port BitlBee will be listening to.
        '';
      };

    };

    gnunet = {
    
      enable = mkOption {
        default = false;
        description = ''
          Whether to run the GNUnet daemon.  GNUnet is GNU's anonymous
          peer-to-peer communication and file sharing framework.
        '';
      };

      home = mkOption {
        default = "/var/lib/gnunet";
        description = ''
          Directory where the GNUnet daemon will store its data.
        '';
      };

      debug = mkOption {
        default = false;
        description = ''
          When true, run in debug mode; gnunetd will not daemonize and
          error messages will be written to stderr instead of a
          logfile.
        '';
      };

      logLevel = mkOption {
        default = "ERROR";
        example = "INFO";
        description = ''
          Log level of the deamon (see `gnunetd(1)' for details).
        '';
      };

      hostLists = mkOption {
        default = [
          "http://gnunet.org/hostlist.php"
          "http://gnunet.mine.nu:8081/hostlist"
          "http://vserver1236.vserver-on.de/hostlist-074"
        ];
        description = ''
          URLs of host lists.
        '';
      };


      applications = mkOption {
        default = [ "advertising" "getoption" "fs" "stats" "traffic" ];
        example = [ "chat" "fs" ];
        description = ''
          List of GNUnet applications supported by the daemon.  Note that
          `fs', which means "file sharing", is probably the one you want.
        '';
      };

      transports = mkOption {
        default = [ "udp" "tcp" "http" "nat" ];
        example = [ "smtp" "http" ];
        description = ''
          List of transport methods used by the server.
        '';
      };

      fileSharing = {
        quota = mkOption {
          default = 1024;
          description = ''
            Maximum file system usage (in MiB) for file sharing.
          '';
        };

        activeMigration = mkOption {
          default = false;
          description = ''
            Whether to allow active migration of content originating
            from other nodes.
          '';
        };
      };

      load = {
        maxNetDownBandwidth = mkOption {
          default = 50000;
          description = ''
            Maximum bandwidth usage (in bits per second) for GNUnet
            when downloading data.
          '';
        };

        maxNetUpBandwidth = mkOption {
          default = 50000;
          description = ''
            Maximum bandwidth usage (in bits per second) for GNUnet
            when downloading data.
          '';
        };

        hardNetUpBandwidth = mkOption {
          default = 0;
          description = ''
            Hard bandwidth limit (in bits per second) when uploading
            data.
          '';
        };

        maxCPULoad = mkOption {
          default = 100;
          description = ''
            Maximum CPU load (percentage) authorized for the GNUnet
            daemon.
          '';
        };

        interfaces = mkOption {
          default = [ "eth0" ];
          example = [ "wlan0" "eth1" ];
          description = ''
            List of network interfaces to use.
          '';
        };
      };

      extraOptions = mkOption {
        default = "";
        example = ''
          [NETWORK]
          INTERFACE = eth3
        '';
        description = ''
          Additional options that will be copied verbatim in `gnunetd.conf'.
          See `gnunetd.conf(5)' for details.
        '';
      };
    };


    ejabberd = {
      enable = mkOption {
        default = false;
        description = "Whether to enable ejabberd server";
      };
            
      spoolDir = mkOption {
        default = "/var/lib/ejabberd";
        description = "Location of the spooldir of ejabberd";
      };
      
      logsDir = mkOption {
        default = "/var/log/ejabberd";
        description = "Location of the logfile directory of ejabberd";
      };
      
      confDir = mkOption {
        default = "/var/ejabberd";
	description = "Location of the config directory of ejabberd";
      };
      
      virtualHosts = mkOption {
        default = "\"localhost\"";
        description = "Virtualhosts that ejabberd should host. Hostnames are surrounded with doublequotes and separated by commas";
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
        default = "tomcat";
        description = "User account under which Apache Tomcat runs.";
      };      
      
      deployFrom = mkOption {
        default = "";
        description = "Location where webapplications are stored. Leave empty to use the baseDir.";
      };
      
      javaOpts = mkOption {
        default = "";
        description = "Parameters to pass to the Java Virtual Machine which spawns Apache Tomcat";
      };
      
      catalinaOpts = mkOption {
        default = "";
        description = "Parameters to pass to the Java Virtual Machine which spawns the Catalina servlet container";
      };
      
      sharedLibFrom = mkOption {
        default = "";
        description = "Location where shared libraries are stored. Leave empty to use the baseDir.";
      };
      
      commonLibFrom = mkOption {
        default = "";
        description = "Location where common libraries are stored. Leave empty to use the baseDir.";
      };
      
      contextXML = mkOption {
        default = "";
        description = "Location of the context.xml to use. Leave empty to use the default.";
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

      extraConfig = mkOption {
        default = "";
        description = "
          These configuration lines will be passed verbatim to the apache config
        ";
      };

      extraModules = mkOption {
        default = [];
        example = [ "proxy_connect" { name = "php5_module"; path = "${pkgs.php}/modules/libphp5.so"; } ];
        description = ''
          Specifies additional Apache modules.  These can be specified
          as a string in the case of modules distributed with Apache,
          or as an attribute set specifying the
          <varname>name</varname> and <varname>path</varname> of the
          module.
        '';
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

      writeEnable = mkOption {
        default = false;
        description = "
          Whether any write activity is permitted to users.
        ";
      };

      anonymousUploadEnable = mkOption {
        default = false;
        description = "
          Whether any uploads are permitted to anonymous users.
        ";
      };

      anonymousMkdirEnable = mkOption {
        default = false;
        description = "
          Whether mkdir is permitted to anonymous users.
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


    udev = {

      addFirmware = mkOption {
        default = [];
        example = ["/mnt/big-storage/firmware/"];
        description = "
          To specify firmware that is not too spread to ensure 
          a package, or have an interactive process of extraction
          and cannot be redistributed.
        ";
        merge = pkgs.lib.mergeListOption;
      };

      addUdevPkgs = mkOption {
        default = [];
        description = "
          List of packages containing udev rules.
        ";
        merge = pkgs.lib.mergeListOption;
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

      waitPingableBroker = mkOption {
        default = true;
        example = false;
        description = "
          Whether to wait until tunnel broker returns ICMP echo.
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
        default = "mysql";
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
      
      pidDir = mkOption {
        default = "/var/run/mysql";
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
          local all all              ident sameuser
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

    
    postfix = {
      enable = mkOption {
        default = false;
        description ="
          Whether to run the Postfix mail server.
        ";
      };
      user = mkOption {
        default = "postfix";
        description = "
          How to call postfix user (must be used only for postfix).
        ";
      };
      group = mkOption {
        default = "postfix";
        description = "
          How to call postfix group (must be used only for postfix).
        ";
      };
      setgidGroup = mkOption {
        default = "postdrop";
        description = "
          How to call postfix setgid group (for postdrop). Should 
          be uniquely used group.
        ";
      };
      networks = mkOption {
        default = null;
        example = ["192.168.0.1/24"];
        description = "
          Net masks for trusted - allowed to relay mail to third parties - 
          hosts. Leave empty to use mynetworks_style configuration or use 
          default (localhost-only).
        ";
      };
      networksStyle = mkOption {
        default = "";
        description = "
          Name of standard way of trusted network specification to use,
          leave blank if you specify it explicitly or if you want to use 
          default (localhost-only).
        ";
      };
      hostname = mkOption {
        default = "";
        description ="
          Hostname to use. Leave blank to use just the hostname of machine.
          It should be FQDN.
        ";
      };
      domain = mkOption {
        default = "";
        description ="
          Domain to use. Leave blank to use hostname minus first component.
        ";
      };
      origin = mkOption {
        default = "";
        description ="
          Origin to use in outgoing e-mail. Leave blank to use hostname.
        ";
      };
      destination = mkOption {
        default = null;
        example = ["localhost"];
        description = "
          Full (!) list of domains we deliver locally. Leave blank for 
          acceptable Postfix default.
        ";
      };
      relayDomains = mkOption {
        default = null;
        example = ["localdomain"];
        description = "
          List of domains we agree to relay to. Default is the same as 
          destination.
        ";
      };
      relayHost = mkOption {
        default = "";
        description = "
          Mail relay for outbound mail.
        ";
      };
      lookupMX = mkOption {
        default = false;
        description = "
          Whether relay specified is just domain whose MX must be used.
        ";
      };
      postmasterAlias = mkOption {
        default = "root";
        description = "
          Who should receive postmaster e-mail.
        ";
      };
      rootAlias = mkOption {
        default = "";
        description = "
          Who should receive root e-mail. Blank for no redirection.
        ";
      };
      extraAliases = mkOption {
        default = "";
        description = "
          Additional entries to put verbatim into aliases file.
        ";
      };

      sslCert = mkOption {
        default = "";
        description = "
          SSL certificate to use.
        ";
      };
      sslCACert = mkOption {
        default = "";
        description = "
          SSL certificate of CA.
        ";
      };
      sslKey = mkOption {
        default = "";
        description ="
          SSL key to use.
        ";
      };

      recipientDelimiter = mkOption {
        default = "";
        example = "+";
        description = "
          Delimiter for address extension: so mail to user+test can be handled by ~user/.forward+test
        ";
      };

    };

    dovecot = {
      enable = mkOption {
        default = false;
        description = "Whether to enable dovecot POP3/IMAP server.";
      };

      user = mkOption {
        default = "dovecot";
        description = "dovecot user name";
      };
      group = mkOption {
        default = "dovecot";
        description = "dovecot group name";
      };

      sslServerCert = mkOption {
        default = "";
        description = "Server certificate";
      };
      sslCACert = mkOption {
        default = "";
        description = "CA certificate used by server certificate";
      };
      sslServerKey = mkOption {
        default = "";
        description = "Server key";
      };
    };

    bind = {
      enable = mkOption {
        default = false;
        description = "
          Whether to enable BIND domain name server.
        ";
      };
      cacheNetworks = mkOption {
        default = ["127.0.0.0/24"];
        description = "
          What networks are allowed to use us as a resolver.
        ";
      };
      blockedNetworks = mkOption {
        default = [];
        description = "
          What networks are just blocked.
        ";
      };
      zones = mkOption {
        default = [];
        description = "
          List of zones we claim authority over.
            master=false means slave server; slaves means addresses 
           who may request zone transfer.
        ";
        example = [{
          name = "example.com";
          master = false;
          file = "/var/dns/example.com";
          masters = ["192.168.0.1"];
          slaves = [];
        }];
      };
    };

  };

  installer = {

    nixpkgsURL = mkOption {
      default = "";
      example = http://nixos.org/releases/nix/nixpkgs-0.11pre7577;
      description = "
        URL of the Nixpkgs distribution to use when building the
        installation CD.
      ";
    };

    repos = {
      nixos = mkOption {
        default = [ { type  = "svn"; }  ];
        example = [ { type = "svn"; url = "https://svn.nixos.org/repos/nix/nixos/branches/stdenv-updates"; target = "/etc/nixos/nixos-stdenv-updates"; }
                    { type = "git"; initialize = ''git clone git://mawercer.de/nixos $target''; update = "git pull origin"; target = "/etc/nixos/nixos-git"; }
                  ];
        description = ''
          The NixOS repository from which the system will be built.
          <command>nixos-checkout</command> will update all working
          copies of the given repositories,
          <command>nixos-rebuild</command> will use the first item
          which has the attribute <literal>default = true</literal>
          falling back to the first item. The type defines the
          repository tool added to the path. It also defines a "valid"
          repository.  If the target directory already exists and it's
          not valid it will be moved to the backup location
          <filename><replaceable>dir</replaceable>-date</filename>.
          For svn the default target and repositories are
          <filename>/etc/nixos/nixos</filename> and
          <filename>https://svn.nixos.org/repos/nix/nixos/trunk</filename>.
          For git repositories update is called after initialization
          when the repo is initialized.  The initialize code is run
          from working directory dirname
          <replaceable>target</replaceable> and should create the
          directory
          <filename><replaceable>dir</replaceable></filename>. (<command>git
          clone url nixos/nixpkgs/services</command> should do) For
          the executables used see <option>repoTypes</option>.
        '';
      };

      nixpkgs = mkOption {
        default = [ { type  = "svn"; }  ];
        description = "same as <option>repos.nixos</option>";
      };

      services = mkOption {
        default = [ { type  = "svn"; } ];
        description = "same as <option>repos.nixos</option>";
      };
    };

    repoTypes = mkOption {
      default = {
        svn = { valid = "[ -d .svn ]"; env = [ pkgs.coreutils pkgs.subversion ]; };
        git = { valid = "[ -d .git ]"; env = [ pkgs.coreutils pkgs.git pkgs.gnused /*  FIXME: use full path to sed in nix-pull */ ]; };
      };
      description = ''
        Defines, for each supported version control system
        (e.g. <literal>git</literal>), the dependencies for the
        mechanism, as well as a test used to determine whether a
        directory is a checkout created by that version control
        system.
      '';
    };

    manifests = mkOption {
      default = [http://nixos.org/releases/nixpkgs/channels/nixpkgs-unstable/MANIFEST];
      example =
        [ http://nixos.org/releases/nixpkgs/channels/nixpkgs-unstable/MANIFEST
          http://nixos.org/releases/nixpkgs/channels/nixpkgs-stable/MANIFEST
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

    # Environment variables for running Nix.
    envVars = mkOption {
      internal = true;
      default = "";
      description = "
        Define the environment variables used by nix to 
      ";

      merge = pkgs.lib.mergeStringOption;

      # other option should be used to define the content instead of using
      # the apply function.
      apply = conf: ''
        export NIX_CONF_DIR=/nix/etc/nix

        # Enable the copy-from-other-stores substituter, which allows builds
        # to be sped up by copying build results from remote Nix stores.  To
        # do this, mount the remote file system on a subdirectory of
        # /var/run/nix/remote-stores.
        export NIX_OTHER_STORES=/var/run/nix/remote-stores/*/nix
        
      '' + # */
      (if config.nix.distributedBuilds then
        ''
          export NIX_BUILD_HOOK=${config.environment.nix}/libexec/nix/build-remote.pl
          export NIX_REMOTE_SYSTEMS=/etc/nix.machines
          export NIX_CURRENT_LOAD=/var/run/nix/current-load
        ''
      else "") + conf;
    };
  };


  security = {

    setuidPrograms = mkOption {
      default = [
        "passwd" "su" "crontab" "ping" "ping6"
        "fusermount" "wodim" "cdrdao" "growisofs"
      ];
      description = "
        Only the programs from system path listed her will be made setuid root
        (through a wrapper program).  It's better to set
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

    setuidOwners = mkOption {
      default = [];
      example = [{
        program = "sendmail";
        owner = "nodody";
        group = "postdrop";
        setuid = false;
        setgid = true;
      }];
      description = ''
        List of non-trivial setuid programs from system path, like Postfix sendmail. Default 
        should probably be nobody:nogroup:false:false - if you are bothering
        doing anything with a setuid program, "root.root u+s g-s" is not what
        you are aiming at..
      '';
    };

    seccureKeys = {
      public = mkOption {
        default = /var/elliptic-keys/public;
        description = "
          Public key. Make it path argument, so it is copied into store and
          hashed. 

          The key is used to encrypt Gateway 6 configuration in store, as it
          contains a password for external service. Unfortunately, 
          derivation file should be protected by other means. For example, 
          nix-http-export.cgi will happily export any non-derivation path,
          but not a derivation.
        ";
      };
      private = mkOption {
        default = "/var/elliptic-keys/private";
        description = "
          Private key. Make it string argument, so it is not copied into store.
        ";
      };
    };

  };


  users = {

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
      default = ["/bin" "/sbin" "/lib" "/share" "/man" "/info"];
      example = ["/"];
      description = "
        Lists directories to be symlinked in `/var/run/current-system/sw'.
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
      default = [];
      example = [pkgs.firefox pkgs.thunderbird];
      merge = backwardPkgsFunListMerge;
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
      default = pkgs.nixUnstable;
      example = pkgs.nixCustomFun /root/nix.tar.gz;
      merge = backwardPkgsFunMerge;
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

    unixODBCDrivers = mkOption {
      default = pkgs : [];
      example = "pkgs : map (x : x.ini) (with pkgs.unixODBCDrivers; [ mysql psql psqlng ] )";
      description = "specifies unix odbc drivers to be registered at /etc/odbcinst.ini";
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

    # security
    (import ../system/sudo.nix)

    # environment
    (import ../etc/default.nix)

    # users
    (import ../system/users-groups.nix)

    # newtworking
    (import ../upstart-jobs/dhclient.nix)

    # hardware
    (import ../upstart-jobs/pcmcia.nix)

    # services
    (import ../upstart-jobs/avahi-daemon.nix)
    (import ../upstart-jobs/atd.nix)
    (import ../upstart-jobs/dbus.nix)
    (import ../upstart-jobs/hal.nix)
    (import ../upstart-jobs/gpm.nix)
    (import ../upstart-jobs/nagios/default.nix)
    (import ../upstart-jobs/xserver.nix)
    (import ../upstart-jobs/zabbix-agent.nix)
    (import ../upstart-jobs/zabbix-server.nix)
    (import ../upstart-jobs/disnix.nix)
    (import ../upstart-jobs/cron.nix)
    (import ../upstart-jobs/fcron.nix)
    (import ../upstart-jobs/cron/locate.nix)

    # fonts
    (import ../system/fonts.nix)

    # sound
    (import ../upstart-jobs/alsa.nix)
  ];
}
