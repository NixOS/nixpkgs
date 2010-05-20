# This test runs a Bittorrent tracker on one machine, and verifies
# that two client machines can download the torrent using
# `transmission'.  The first client (behind a NAT router) downloads
# from the initial seeder running on the tracker.  Then we kill the
# initial seeder.  The second client downloads from the first client,
# which only works if the first client successfully uses the UPnP-IGD
# protocol to poke a hole in the NAT.

{ pkgs, ... }:

let

  # Some random file to serve.
  file = pkgs.nixUnstable.src;

  miniupnpdConf = pkgs.writeText "miniupnpd.conf"
    ''
      ext_ifname=eth1
      listening_ip=192.168.2.3/24
      allow 1024-65535 192.168.2.0/24 1024-65535
    '';
  
in

{

  nodes =
    { tracker = 
        { config, pkgs, ... }:
        { environment.systemPackages = [ pkgs.transmission pkgs.bittorrent ];

          # We need Apache on the tracker to serve the torrents.
          services.httpd.enable = true;
          services.httpd.adminAddr = "foo@example.org";
          services.httpd.documentRoot = "/tmp";
        };

      router = 
        { config, pkgs, ... }:
        { environment.systemPackages = [ pkgs.iptables pkgs.miniupnpd ];
          virtualisation.vlans = [ 1 2 ];
        };

      client1 = 
        { config, pkgs, ... }:
        { environment.systemPackages = [ pkgs.transmission ];
          virtualisation.vlans = [ 2 ];
          networking.defaultGateway = "192.168.2.3"; # !!! ugly
        };

      client2 = 
        { config, pkgs, ... }:
        { environment.systemPackages = [ pkgs.transmission ];
        };
    };

  testScript =
    ''
      startAll;

      # Enable NAT on the router and start miniupnpd.
      $router->mustSucceed(
          "iptables -t nat -F",
          "iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -d 192.168.2.0/24 -j ACCEPT",
          "iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -j SNAT --to-source 192.168.1.3", # !!! ugly
          "iptables -t nat -N MINIUPNPD",
          "iptables -t nat -A PREROUTING -i eth1 -j MINIUPNPD",
          "echo 1 > /proc/sys/net/ipv4/ip_forward",
          "miniupnpd -f ${miniupnpdConf}"
      );

      # Create the torrent.
      $tracker->mustSucceed("mkdir /tmp/data");
      $tracker->mustSucceed("cp ${file} /tmp/data/test.tar.bz2");
      $tracker->mustSucceed("transmissioncli -n /tmp/data/test.tar.bz2 -a http://tracker:6969/announce /tmp/test.torrent");
      $tracker->mustSucceed("chmod 644 /tmp/test.torrent");

      # Start the tracker.  !!! use a less crappy tracker
      $tracker->mustSucceed("bittorrent-tracker --port 6969 --dfile /tmp/dstate >&2 &");
      $tracker->waitForOpenPort(6969);

      # Start the initial seeder.
      my $pid = $tracker->mustSucceed("transmissioncli /tmp/test.torrent -M -w /tmp/data >&2 & echo \$!");

      # Now we should be able to download from the client behind the NAT.
      $tracker->waitForJob("httpd");
      $client1->mustSucceed("transmissioncli http://tracker/test.torrent -w /tmp >&2 &");
      $client1->waitForFile("/tmp/test.tar.bz2");
      $client1->mustSucceed("cmp /tmp/test.tar.bz2 ${file}");

      # Bring down the initial seeder.
      $tracker->mustSucceed("kill -9 $pid");

      # Now download from the second client.  This can only succeed if
      # the first client created a NAT hole in the router.
      $client2->mustSucceed("transmissioncli http://tracker/test.torrent -M -w /tmp >&2 &");
      $client2->waitForFile("/tmp/test.tar.bz2");
      $client2->mustSucceed("cmp /tmp/test.tar.bz2 ${file}");
    '';
  
}
