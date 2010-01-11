{ pkgs, ... }:

let

  backend = 
    { config, pkgs, ... }:

    {
      services.sshd.enable = true;

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

      $proxy->waitForJob("httpd");
      $backend1->waitForJob("httpd");
      $backend2->waitForJob("httpd");

      # With the back-ends up, the proxy should work.
      $client->mustSucceed("curl --fail http://proxy/");

      $client->mustSucceed("curl --fail http://proxy/server-status");

      # Block the first back-end.
      $backend1->block;

      # The proxy should still work.
      $client->mustSucceed("curl --fail http://proxy/");

      $client->mustSucceed("curl --fail http://proxy/");

      # Block the second back-end.
      $backend2->block;

      # Now the proxy should fail as well.
      $client->mustFail("curl --fail http://proxy/");

      # But if the second back-end comes back, the proxy should start
      # working again.
      $backend2->unblock;
      $client->mustSucceed("curl --fail http://proxy/");
    '';

}
