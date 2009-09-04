{ nixos ? ./..
, nixpkgs ? /etc/nixos/nixpkgs
, services ? /etc/nixos/services
, system ? builtins.currentSystem
}:

with import ../lib/build-vms.nix { inherit nixos nixpkgs services system; };

rec {
  nodes = {
    storage = 
      {pkgs, config, ...}:
      {
        services = {
          portmap = {
            enable = true;
          };
    
          nfsKernel = {
            enable = true;
            exports = ''
              /repos/trac 192.168.1.0/255.255.255.0(rw,no_root_squash)
            '';
          };    
        };
  
        environment = {
          extraPackages = [
            pkgs.subversion
          ];
        };
      };

    postgresql =
      {config, pkgs, ...}:
      {
        services = {
          sshd = {
            enable = true;
          };
    
          postgresql = {
            enable = true;
      
            authentication = ''
              # Generated file; do not edit!
              local all all              trust
              host  all all 127.0.0.1/32 trust
	      host  all all ::1/128      trust
            '';
          };
        };  
      };

    webserver = 
      {config, pkgs, ...}:
      {
        services = {
          nfsKernel = {
            enable = true;
          };
  
          httpd = {
            enable = true;
            adminAddr = "root@localhost";
            extraSubservices = [
	      { serviceType = "trac"; }
            ];
          };
        };
	
	environment = {
	  extraPackages = [ pkgs.pythonPackages.trac ];
	};
      };
      
    client = 
      {config, pkgs, ...}:
      {
        services = {
	  xserver = {
	    enable = true;
            driSupport = true;
	  };
	};
	  
        environment = {
	  extraPackages = [
	    pkgs.firefox
	    pkgs.icewm
	    pkgs.scrot
	  ];
	};
      };
  };
    
  vms = buildVirtualNetwork { inherit nodes; };

  test = runTests vms
    ''
      startAll;
      
      $storage->mustSucceed("mkdir -p /repos/trac");
      $storage->mustSucceed("svnadmin create /repos/trac");
      $webserver->mustSucceed("mount storage:/repos/trac /repos/trac");
      
      #$postgresql->waitForFile("/tmp/.s.PGSQL.5432");
      #$postgresql->mustSucceed("createdb trac");
      
      $webserver->waitForFile("/var/trac");
      $webserver->mustSucceed("PYTHONPATH=${pkgs.pythonPackages.psycopg2}/lib/python2.5/site-packages trac-admin /var/trac/projects/test initenv Test postgres://root\@postgresql/trac svn /repos/trac -v");
      
      sleep 10;
      
      $client->waitForFile("/tmp/.X11-unix/X0");
      print STDERR $client->execute("DISPLAY=:0.0 icewm &");
      print STDERR $client->execute("DISPLAY=:0.0 firefox http://webserver/projects/test &");
      
      sleep 40;
      
      print STDERR $client->execute("DISPLAY=:0.0 scrot /hostfs/$ENV{out}/screen1.png");
    '';
}
