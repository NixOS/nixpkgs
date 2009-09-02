{ nixos ? ./..
, nixpkgs ? /etc/nixos/nixpkgs
, services ? /etc/nixos/services
, system ? builtins.currentSystem
}:

with import ../lib/build-vms.nix { inherit nixos nixpkgs services system; };

rec {

  nodes =
    { client =
        { config, pkgs, ... }:

        { services.xserver.enable = true;
          services.xserver.driSupport = true;
        
          environment.systemPackages = [ pkgs.scrot pkgs.xorg.twm pkgs.quake3demo ];
        };
    };

  vms = buildVirtualNetwork { inherit nodes; };

  test = runTests vms
    ''
      startAll;

      $client->waitForFile("/tmp/.X11-unix/X0");

      sleep 20;

      print STDERR $client->execute("DISPLAY=:0.0 quake3 &");

      sleep 20;

      print STDERR $client->execute("DISPLAY=:0.0 scrot /hostfs/$ENV{out}/screen.png");
    '';
  
}
