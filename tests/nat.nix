# This is a simple distributed test involving a topology with two
# separate virtual networks - the "inside" and the "outside" - with a
# client on the inside network, a server on the outside network, and a
# router connected to both that performs Network Address Translation
# for the client.

{ pkgs, ... }:

{

  nodes =
    { client = 
        { config, pkgs, nodes, ... }:
        { virtualisation.vlans = [ 1 ];
          networking.defaultGateway =
            nodes.router.config.networking.ifaces.eth2.ipAddress;
        };

      router = 
        { config, pkgs, ... }:
        { virtualisation.vlans = [ 2 1 ];
          environment.systemPackages = [ pkgs.iptables ];
        };

      server = 
        { config, pkgs, ... }:
        { virtualisation.vlans = [ 2 ];
          services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
        };
    };

  testScript =
    { nodes, ... }:
    ''
      startAll;

      # The router should have access to the server.
      $server->waitForJob("httpd");
      $router->mustSucceed("curl --fail http://server/ >&2");

      # But the client shouldn't be able to reach the server.
      $client->mustFail("curl --fail --connect-timeout 5 http://server/ >&2");

      # Enable NAT on the router.
      $router->mustSucceed(
          "iptables -t nat -F",
          "iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -d 192.168.1.0/24 -j ACCEPT",
          "iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -j SNAT "
          . "--to-source ${nodes.router.config.networking.ifaces.eth1.ipAddress}",
          "echo 1 > /proc/sys/net/ipv4/ip_forward"
      );

      # Now the client should be able to connect.
      $client->mustSucceed("curl --fail http://server/ >&2");
    '';

}
