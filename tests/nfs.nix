{ pkgs, ... }:

{

  nodes =
    { client = 
        { config, pkgs, ... }:
        { services.nfsKernel.client.enable = true;
          fileSystems = pkgs.lib.mkOverride 50 {} 
            [ { mountPoint = "/data";
                device = "server:/data";
                fsType = "nfs";
                options = "bootwait";
              } 
            ];
        };

      server = 
        { config, pkgs, ... }:
        { services.nfsKernel.server.enable = true;
          services.nfsKernel.server.exports =
            ''
              /data 192.168.1.0/255.255.255.0(rw,no_root_squash)
            '';
          services.nfsKernel.server.createMountPoints = true;
        };
    };

  testScript =
    ''
      startAll;

      $server->waitForJob("nfs-kernel-nfsd");
      $server->waitForJob("nfs-kernel-mountd");
      $server->waitForJob("nfs-kernel-statd");

      $client->waitForJob("nfs-kernel-statd");

      $client->waitForJob("tty1"); # depends on filesystems

      $client->succeed("echo bar > /data/foo");
      $server->succeed("test -e /data/foo");

      $client->shutdown;
    '';

}
