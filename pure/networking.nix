{

  identification = {
    fromDHCP = false;
    hostname = "foobar";
  };


  interfaces = [

    # Manual configuration.
    { name = "eth0";
      hardware = {
        type = "ethernet";
        device = "net-dev-1";
      };
      link = {
        ip4 = {
          address = "192.168.1.2";
          nameservers = [ # to be used when this interface is up
            "1.2.3.4";
            "1.2.3.5";
          ];
          routes = [ # idem, add when up
            { destination = "0.0.0.0";
              netmask = "0.0.0.0";
              gateway = "192.168.1.1";
              # iface implied (eth0)
            }
            { destination = "192.168.1.0";
              netmask = "255.255.255.0";
              # iface implied (eth0)
            }
          ];
        };
        ip6 = ...;
      };
    }

    # Automatic configuration via DHCP
    { name = "eth0";
      hardware = {
        type = "ethernet";
        device = "net-dev-1";
      };
      link = {
        useDHCP = true;
      };
    }
    
  ];


  firewall = {
    # ...
  };

}