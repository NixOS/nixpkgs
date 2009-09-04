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
              /repos 192.168.1.0/255.255.255.0(rw,no_root_squash)
            '';
	    createMountPoints = true;
          };    
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
    	    enableTCPIP = true;
	    
            authentication = ''
              # Generated file; do not edit!
              local all all                trust
              host  all all 127.0.0.1/32   trust
	      host  all all ::1/128        trust
	      host  all all 192.168.1.0/24 trust
            '';
          };
        };  
      };

    webserver = 
      {config, pkgs, ...}:
      {
        fileSystems = pkgs.lib.mkOverride 50 {} 
	[ 
	  { mountPoint = "/repos";
	    device = "storage:/repos"; } 
	];
      
        services = {
	  portmap = {
	    enable = true;
	  };

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
	  extraPackages = [ pkgs.pythonPackages.trac pkgs.subversion ];
	};
      };
      
    client = 
      {config, pkgs, ...}:
      {
        services = {
	  xserver = {
	    enable = true;

            displayManager = {
	      slim = {
	        enable = false;
	      };
              kdm = {
	        enable = true;
		extraConfig =
                  ''
                    [X-:0-Core]
                    AutoLoginEnable=true
                    AutoLoginUser=alice
                    AutoLoginPass=foobar
                  '';
	      };
	    };
	    desktopManager = {
	      default = "kde4";
	      kde4 = {
	        enable = true;
	      };
	    };            
	  };
	};
	
	users = {
	  extraUsers = pkgs.lib.singleton { 
	      name = "alice";
              description = "Alice Foobar";
              home = "/home/alice";
              createHome = true;
              useDefaultShell = true;
              password = "foobar";
          };
        };
 
        environment = {
	  extraPackages = [
	    pkgs.scrot
	  ];
	};
      };
  };
    
  vms = buildVirtualNetwork { inherit nodes; };

  test = runTests vms
    ''
      startAll;
      
      $postgresql->waitForFile("/tmp/.s.PGSQL.5432");
      $postgresql->mustSucceed("createdb trac");
      
      $webserver->mustSucceed("mkdir -p /repos/trac");
      $webserver->mustSucceed("svnadmin create /repos/trac");
      
      $webserver->waitForFile("/var/trac");      
      $webserver->mustSucceed("mkdir -p /var/trac/projects/test");
      $webserver->mustSucceed("PYTHONPATH=${pkgs.pythonPackages.psycopg2}/lib/python2.5/site-packages trac-admin /var/trac/projects/test initenv Test postgres://root\@postgresql/trac svn /repos/trac");
      
      $client->waitForFile("/tmp/.X11-unix/X0");
      sleep 60;
      
      print STDERR $client->execute("su - alice -c 'DISPLAY=:0.0 konqueror http://webserver/projects/test &'");
      sleep 120;
      
      print STDERR $client->execute("DISPLAY=:0.0 scrot /hostfs/$ENV{out}/screen1.png");
    '';
}
