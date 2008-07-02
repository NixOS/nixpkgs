{pkgs, config, upstartJobs, defaultShell}:

let ids = import ./ids.nix; in

rec {

  # User accounts to be created/updated by NixOS.
  users =
    let
      jobUsers = pkgs.lib.concatLists (map (job: job.users) upstartJobs.jobs);
      
      defaultUsers =
        [
          { name = "root";
            uid = ids.uids.root;
            description = "System administrator";
            home = "/root";
            shell = defaultShell;
            group = "root";
          }
          { name = "nobody";
            uid = ids.uids.nobody;
            description = "Unprivileged account (don't use!)";
          }
        ];
      
      makeNixBuildUser = nr:
        { name = "nixbld${toString nr}";
          description = "Nix build user ${toString nr}";
          uid = builtins.add ids.uids.nixbld nr;
          extraGroups = ["nixbld"];
        };
        
      nixBuildUsers = map makeNixBuildUser (pkgs.lib.range 1 10);
      
      addAttrs =
        { name
        , description
        , uid ? ""
        , group ? "nogroup"
        , extraGroups ? []
        , home ? "/var/empty"
        , shell ? (if useDefaultShell then defaultShell else "/noshell")
        , createHome ? false
        , useDefaultShell ? false
        }:
        { inherit name description uid group extraGroups home shell createHome; };

    in map addAttrs (defaultUsers ++ jobUsers ++ nixBuildUsers ++ config.users.extraUsers);


  # Groups to be created/updated by NixOS.
  groups =
    let
      jobGroups = pkgs.lib.concatLists (map (job: job.groups) upstartJobs.jobs);

      defaultGroups = 
        [
          { name = "root";
            gid = ids.gids.root;
          }
          { name = "wheel";
            gid = ids.gids.wheel;
          }
          { name = "disk";
            gid = ids.gids.disk;
          }
          { name = "kmem";
            gid = ids.gids.kmem;
          }
          { name = "tty";
            gid = ids.gids.tty;
          }
          { name = "floppy";
            gid = ids.gids.floppy;
          }
          { name = "uucp";
            gid = ids.gids.uucp;
          }
          { name = "lp";
            gid = ids.gids.lp;
          }
          { name = "nogroup";
            gid = ids.gids.nogroup;
          }
          { name = "users";
            gid = ids.gids.users;
          }
          { name = "nixbld";
            gid = ids.gids.nixbld;
          }
        ];

      addAttrs =
        { name, gid ? "" }:
        { inherit name gid; };

    in map addAttrs (defaultGroups ++ jobGroups ++ config.users.extraGroups);


  # Awful hackery necessary to pass the users/groups to the activation script.
  createUsersGroups = ../helpers/create-users-groups.sh;
  usersList = pkgs.writeText "users" (pkgs.lib.concatStrings (map (u: "${u.name}\n${u.description}\n${toString u.uid}\n${u.group}\n${toString (pkgs.lib.concatStringsSep "," u.extraGroups)}\n${u.home}\n${u.shell}\n${toString u.createHome}\n") users));
  groupsList = pkgs.writeText "groups" (pkgs.lib.concatStrings (map (g: "${g.name}\n${toString g.gid}\n") groups));
    
}
