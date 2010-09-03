{ pkgs, ... }:

let

  client = 
    { config, pkgs, ... }:
    { fileSystems = pkgs.lib.mkOverrideTemplate 50 {} 
        [ { mountPoint = "/data";
            device = "server:/data";
            fsType = "nfs";
            options = "bootwait";
          } 
        ];
    };

in

{

  nodes =
    { client1 = client;
      client2 = client;

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

      $client1->waitForJob("tty1"); # depends on filesystems
      $client1->succeed("echo bla > /data/foo");
      $server->succeed("test -e /data/foo");

      $client2->waitForJob("tty1"); # depends on filesystems
      $client2->succeed("echo bla > /data/bar");
      $server->succeed("test -e /data/bar");

      # Test whether we can get a lock.  !!! This step takes about 90
      # seconds because the NFS server waits that long after booting
      # before accepting new locks.
      $client2->succeed("time flock -n -s /data/lock true");
      
      # Test locking: client 1 acquires an exclusive lock, so client 2
      # should then fail to acquire a shared lock.
      $client1->succeed("flock -x /data/lock -c 'touch locked; sleep 100000' &");
      $client1->waitForFile("locked");
      $client2->fail("flock -n -s /data/lock true");

      # Test whether client 2 obtains the lock if we reset client 1.
      $client2->succeed("flock -x /data/lock -c 'echo acquired; touch locked; sleep 100000' >&2 &");
      $client1->crash;
      $client1->start;
      $client2->waitForFile("locked");

      # Test whether locks survive a reboot of the server.
      $client1->waitForJob("tty1"); # depends on filesystems
      $server->shutdown;
      $server->start;
      $client1->succeed("touch /data/xyzzy");
      $client1->fail("time flock -n -s /data/lock true");

      # Test whether unmounting during shutdown happens quickly.  This
      # requires portmap and statd to keep running during the
      # shutdown.
      my $t1 = time;
      $client1->shutdown;
      my $duration = time - $t1;
      die "shutdown took too long ($duration seconds)" if $duration > 30;
    '';

}
