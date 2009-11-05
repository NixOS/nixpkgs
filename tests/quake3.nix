{ nixos ? ./..
, nixpkgs ? /etc/nixos/nixpkgs
, services ? /etc/nixos/services
, system ? builtins.currentSystem
}:

with import ../lib/build-vms.nix { inherit nixos nixpkgs services system; };

rec {

  client = 
    { config, pkgs, ... }:

    { services.xserver.enable = true;
      services.xserver.driSupport = true;
      environment.systemPackages = [ pkgs.scrot pkgs.icewm pkgs.quake3demo ];
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

  vms = buildVirtualNetwork { inherit nodes; };

  test = runTests vms
    ''
      startAll;

      $server->waitForJob("quake3-server");
      $client1->waitForFile("/tmp/.X11-unix/X0");
      $client2->waitForFile("/tmp/.X11-unix/X0");

      sleep 20;

      print STDERR $client1->execute("DISPLAY=:0.0 icewm &");
      print STDERR $client1->execute("DISPLAY=:0.0 quake3 '+set r_fullscreen 0' '+set name Foo' '+connect server' &");
 
      print STDERR $client2->execute("DISPLAY=:0.0 icewm &");
      print STDERR $client2->execute("DISPLAY=:0.0 quake3 '+set r_fullscreen 0' '+set name Bar' '+connect server' &");
 
      sleep 40;

      $server->mustSucceed("grep -q 'Foo.*entered the game' /tmp/log");
      $server->mustSucceed("grep -q 'Bar.*entered the game' /tmp/log");
      
      print STDERR $client1->execute("DISPLAY=:0.0 scrot /hostfs/$ENV{out}/screen1.png");
      print STDERR $client2->execute("DISPLAY=:0.0 scrot /hostfs/$ENV{out}/screen2.png");
    '';
  
}
