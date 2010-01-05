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
        [ 
          { mountPoint = "/repos";
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
        services.xserver.enable = true;
        services.xserver.displayManager.slim.enable = false;
        services.xserver.displayManager.kdm.enable = true;
        services.xserver.displayManager.kdm.extraConfig =
          ''
            [X-:0-Core]
            AutoLoginEnable=true
            AutoLoginUser=alice
            AutoLoginPass=foobar
          '';
        services.xserver.desktopManager.default = "kde4";
        services.xserver.desktopManager.kde4.enable = true;
        users.extraUsers = pkgs.lib.singleton { 
          name = "alice";
          description = "Alice Foobar";
          home = "/home/alice";
          createHome = true;
          useDefaultShell = true;
          password = "foobar";
        };
        environment.systemPackages = [ pkgs.scrot ];
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
      $webserver->mustSucceed("PYTHONPATH=${pkgs.pythonPackages.psycopg2}/lib/python2.5/site-packages trac-admin /var/trac/projects/test initenv Test postgres://root\@postgresql/trac svn /repos/trac");
      
      $client->waitForFile("/tmp/.X11-unix/X0");
      sleep 60;
      
      $client->execute("su - alice -c 'DISPLAY=:0.0 konqueror http://webserver/projects/test &'");
      sleep 120;
      
      $client->screenshot("screen");
    '';
}
