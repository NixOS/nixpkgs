[

  (option {
    name = ["networking" "hostname"];
    default = "nixos";
    description = "The name of the machine."
  })

  (option {
    name = ["networking" "useDHCP"];
    default = true;
    description = "
      Whether to use DHCP to obtain an IP adress and other
      configuration for all network interfaces that are not manually
      configured.
    "
  })

  (option {
    name = ["networking" "interfaces"];
    default = [];
    example = [
      { interface = "eth0";
        ipAddress = "131.211.84.78";
        netmask = "255.255.255.128";
        gateway = "131.211.84.1";
      }
    ];
    description = "
      The configuration for each network interface.  If
      <option>networking.useDHCP</option> is true, then each interface
      not listed here will be configured using DHCP.
    "
  })

  (option {
    name = ["filesystems" "mountPoints"];
    example = [
      { device = "/dev/hda2";
        mountPoint = "/";
      }
    ];
    description = "
      The file systems to be mounted by NixOS.  It must include an
      entry for the root directory (<literal>mountPoint =
      \"/\"</literal>).  This is the file system on which NixOS is (to
      be) installed..
    ";
  })

  (option {
    name = ["services" "syslogd" "tty"];
    default = 10;
    description = "
      The tty device on which syslogd will print important log
      messages.
    ";
  })
    
  (option {
    name = ["services" "mingetty" "ttys"];
    default = [1 2 3 4 5 6];
    description = "
      The list of tty (virtual console) devices on which to start a
      login prompt.
    ";
  })
    
  (option {
    name = ["services" "mingetty" "waitOnMounts"];
    default = false;
    description = "
      Whether the login prompts on the virtual consoles will be
      started before or after all file systems have been mounted.  By
      default we don't wait, but if for example your /home is on a
      separate partition, you may want to turn this on.
    ";
  })

  (option {
    name = ["services" "sshd" "enable"];
    default = false;
    description = "
      Whether to enable the Secure Shell daemon, which allows secure
      remote logins.
    ";
  })

  (option {
    name = ["services" "sshd" "forwardX11"];
    default = false;
    description = "
      Whether to enable sshd to forward X11 connections.
    ";
  })

]
