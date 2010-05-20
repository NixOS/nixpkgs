{ pkgs, ... }:

let

  # Some random file to serve.
  file = pkgs.nixUnstable.src;
  
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

      client = 
        { config, pkgs, ... }:
        { environment.systemPackages = [ pkgs.transmission ];
        };
    };

  testScript =
    ''
      startAll;

      # Create the torrent.
      $tracker->mustSucceed("mkdir /tmp/data");
      $tracker->mustSucceed("cp ${file} /tmp/data/test.tar.bz2");
      $tracker->mustSucceed("transmissioncli -n /tmp/data/test.tar.bz2 -a http://tracker:6969/announce /tmp/test.torrent");
      $tracker->mustSucceed("chmod 644 /tmp/test.torrent");

      # Start the tracker.  !!! use a less crappy tracker
      $tracker->mustSucceed("bittorrent-tracker --port 6969 --dfile /tmp/dstate >&2 &");
      $tracker->waitForOpenPort(6969);

      # Start the initial seeder.
      $tracker->mustSucceed("transmissioncli /tmp/test.torrent -M -w /tmp/data >&2 &");

      # Now we should be able to download from the client.
      $tracker->waitForJob("httpd");
      $client->mustSucceed("transmissioncli http://tracker/test.torrent -M -w /tmp >&2 &");
      $client->waitForFile("/tmp/test.tar.bz2");
      $client->mustSucceed("cmp /tmp/test.tar.bz2 ${file}");
    '';
  
}
