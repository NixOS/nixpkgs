# Test the firewall module.

{ pkgs, ... }:

{

  nodes =
    { walled =
        { config, pkgs, nodes, ... }:
        { networking.firewall.enable = true;
          networking.firewall.logRefusedPackets = true;
          services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
        };

      attacker =
        { config, pkgs, ... }:
        { services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
        };
    };

  testScript =
    { nodes, ... }:
    ''
      startAll;

      $walled->waitForJob("firewall");
      $walled->waitForJob("httpd");
      $attacker->waitForJob("network.target");

      # Local connections should still work.
      $walled->succeed("curl -v http://localhost/ >&2");

      # Connections to the firewalled machine should fail.
      $attacker->fail("curl -v http://walled/ >&2");
      $attacker->fail("ping -c 1 walled >&2");

      # Outgoing connections/pings should still work.
      $walled->succeed("curl -v http://attacker/ >&2");
      $walled->succeed("ping -c 1 attacker >&2");

      # If we stop the firewall, then connections should succeed.
      $walled->succeed("stop firewall");
      $attacker->succeed("curl -v http://walled/ >&2");
    '';

}
