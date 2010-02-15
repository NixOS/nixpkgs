{ pkgs, ... }:

{
  nodes = {
    storage = 
      {pkgs, config, ...}:
      {
        services.portmap.enable = true;
        services.nfsKernel.enable = true;
        services.nfsKernel.exports = ''
          /repos 192.168.1.0/255.255.255.0(rw,no_root_squash)
        '';
        services.nfsKernel.createMountPoints = true;
      };

    postgresql =
      {config, pkgs, ...}:
      {
        services.sshd.enable = true;
        services.postgresql.enable = true;
        services.postgresql.enableTCPIP = true;
        services.postgresql.authentication = ''
          # Generated file; do not edit!
          local all all                trust
          host  all all 127.0.0.1/32   trust
          host  all all ::1/128        trust
          host  all all 192.168.1.0/24 trust
        '';
      };

    webserver = 
      {config, pkgs, ...}:
      {
        fileSystems = pkgs.lib.mkOverride 50 {} 
          [ { mountPoint = "/repos";
              device = "storage:/repos"; } 
          ];
      
        services.portmap.enable = true;
        services.httpd.enable = true;
        services.httpd.adminAddr = "root@localhost";
        services.httpd.extraSubservices = [ { serviceType = "trac"; } ];
        environment.systemPackages = [ pkgs.pythonPackages.trac pkgs.subversion ];
      };
      
    client = 
      {config, pkgs, ...}:
      {
        require = [ ./common/x11.nix ];
        services.xserver.desktopManager.kde4.enable = true;
      };
  };
    
  testScript =
    ''
      startAll;
      
      $postgresql->waitForJob("postgresql");
      $postgresql->mustSucceed("createdb trac");
      
      $webserver->mustSucceed("mkdir -p /repos/trac");
      $webserver->mustSucceed("svnadmin create /repos/trac");
      
      $webserver->waitForFile("/var/trac");      
      $webserver->mustSucceed("mkdir -p /var/trac/projects/test");
      $webserver->mustSucceed("PYTHONPATH=${pkgs.pythonPackages.psycopg2}/lib/${pkgs.python.libPrefix}/site-packages trac-admin /var/trac/projects/test initenv Test postgres://root\@postgresql/trac svn /repos/trac");
      
      $client->waitForX;
      $client->execute("konqueror http://webserver/projects/test &");
      $client->waitForWindow(qr/Test.*Konqueror/);
      sleep 30; # loading takes a long time
      
      $client->screenshot("screen");
    '';
}
