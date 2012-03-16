{ pkgs, ... }:

let

  client =
    { config, pkgs, ... }:
    { fileSystems = pkgs.lib.mkOverride 50
        [ { mountPoint = "/data";
            device = "server:/data";
            fsType = "nfs";
            options = "bootwait,vers=3";
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
        { services.nfs.server.enable = true;
          services.nfs.server.exports =
            ''
              /data 192.168.1.0/255.255.255.0(rw,no_root_squash)
            '';
          services.nfs.server.createMountPoints = true;
        };
    };

  testScript =
    ''
      $server->waitForJob("nfsd");

      startAll;

      $client1->waitForJob("tty1"); # depends on filesystems
      $client1->succeed("echo bla > /data/foo");
      $server->succeed("test -e /data/foo");

      $client2->waitForJob("tty1"); # depends on filesystems
      $client2->succeed("echo bla > /data/bar");
      $server->succeed("test -e /data/bar");

      # Test whether restarting ‘nfsd’ works correctly.
      $server->succeed("stop nfsd; start nfsd");
      $client2->succeed("echo bla >> /data/bar"); # will take 90 seconds due to the NFS grace period

      # Test whether we can get a lock.
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

      # Test whether unmounting during shutdown happens quickly.
      my $t1 = time;
      $client1->shutdown;
      my $duration = time - $t1;
      die "shutdown took too long ($duration seconds)" if $duration > 30;
    '';

}
