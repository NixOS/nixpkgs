{ pkgs, ... }:

rec {

  client = 
    { config, pkgs, ... }:

    { require = [ ./common/x11.nix ];
      services.xserver.driSupport = true;
      services.xserver.defaultDepth = pkgs.lib.mkOverrideTemplate 0 {} 16;
      environment.systemPackages = [ pkgs.icewm pkgs.quake3demo ];
    };

  nodes =
    { server =
        { config, pkgs, ... }:

        { jobs.quake3Server =
            { name = "quake3-server";
              startOn = "startup";
              exec =
                "${pkgs.quake3demo}/bin/quake3 '+set dedicated 1' '+set g_gametype 0' " +
                "'+map q3dm7' '+addbot grunt' '+addbot daemia' 2> /tmp/log";
            };
        };

      client1 = client;
      client2 = client;
    };

  testScript =
    ''
      startAll;

      $server->waitForJob("quake3-server");
      $client1->waitForX;
      $client2->waitForX;

      $client1->execute("quake3 '+set r_fullscreen 0' '+set name Foo' '+connect server' &");
      $client2->execute("quake3 '+set r_fullscreen 0' '+set name Bar' '+connect server' &");
 
      $server->waitUntilSucceeds("grep -q 'Foo.*entered the game' /tmp/log");
      $server->waitUntilSucceeds("grep -q 'Bar.*entered the game' /tmp/log");

      sleep 30; # wait for a while to get a nice screenshot

      $client1->screenshot("screen1");
      $client2->screenshot("screen2");
    '';
  
}
