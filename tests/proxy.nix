{ pkgs, ... }:

let

  backend =
    { config, pkgs, ... }:

    {
      services.openssh.enable = true;

      services.httpd.enable = true;
      services.httpd.adminAddr = "foo@example.org";
      services.httpd.documentRoot = "${pkgs.valgrind}/share/doc/valgrind/html";
    };

in

{

  nodes =
    { proxy =
        { config, pkgs, nodes, ... }:

        {
          services.httpd.enable = true;
          services.httpd.adminAddr = "bar@example.org";
          services.httpd.extraModules = ["proxy_balancer"];

          services.httpd.extraConfig =
            ''
              ExtendedStatus on

              <Location /server-status>
                Order deny,allow
                Allow from all
                SetHandler server-status
              </Location>

              <Proxy balancer://cluster>
                Allow from all
                BalancerMember http://${nodes.backend1.config.networking.hostName} retry=0
                BalancerMember http://${nodes.backend2.config.networking.hostName} retry=0
              </Proxy>

              ProxyStatus       full
              ProxyPass         /server-status !
              ProxyPass         /       balancer://cluster/
              ProxyPassReverse  /       balancer://cluster/

              # For testing; don't want to wait forever for dead backend servers.
              ProxyTimeout      5
            '';
        };

      backend1 = backend;
      backend2 = backend;

      client = { config, pkgs, ... }: { };
    };

  testScript =
    ''
      startAll;

      $proxy->waitForUnit("httpd");
      $backend1->waitForUnit("httpd");
      $backend2->waitForUnit("httpd");

      # With the back-ends up, the proxy should work.
      $client->succeed("curl --fail http://proxy/");

      $client->succeed("curl --fail http://proxy/server-status");

      # Block the first back-end.
      $backend1->block;

      # The proxy should still work.
      $client->succeed("curl --fail http://proxy/");

      $client->succeed("curl --fail http://proxy/");

      # Block the second back-end.
      $backend2->block;

      # Now the proxy should fail as well.
      $client->fail("curl --fail http://proxy/");

      # But if the second back-end comes back, the proxy should start
      # working again.
      $backend2->unblock;
      $client->succeed("curl --fail http://proxy/");
    '';

}
