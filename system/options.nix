{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mergeOneOption;
in

{

  boot = {

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


  nesting = {
    children = mkOption {
      default = [];
      description = "
        Additional configurations to build.
      ";
    };
  };

  
  require = import ../modules/module-list.nix;
}
