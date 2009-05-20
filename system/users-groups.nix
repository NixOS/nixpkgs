{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption;

  options = {
    users = {
      extraUsers = mkOption {
        default = [];
        example = [
          { name = "alice";
            uid = 1234;
            description = "Alice";
            home = "/home/alice";
            createHome = true;
            group = "users";
            extraGroups = ["wheel"];
            shell = "/bin/sh";
          }
        ];
        description = "
          Additional user accounts to be created automatically by the system.
        ";
      };

      extraGroups = mkOption {
        default = [];
        example = [
          { name = "students";
            gid = 1001;
          }
        ];
        description = "
          Additional groups to be created automatically by the system.
        ";
      };
    };
  };
in

###### implementation
let
  ids = import ./ids.nix;
  defaultShell = config.system.shell;

  # User accounts to be created/updated by NixOS.
  users =
    let
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

    in map addAttrs (defaultUsers ++ nixBuildUsers ++ config.users.extraUsers);


  # Groups to be created/updated by NixOS.
  groups =
    let
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

    in map addAttrs (defaultGroups ++ config.users.extraGroups);

  inherit (pkgs.lib) concatStringsSep;

  serializedUser = u: "${u.name}\n${u.description}\n${toString u.uid}\n${u.group}\n${toString (concatStringsSep "," u.extraGroups)}\n${u.home}\n${u.shell}\n${toString u.createHome}";
  serializedGroup = g: "${g.name}\n${toString g.gid}";
in

let
  inherit (pkgs.stringsWithDeps) fullDepEntry;

  # keep this extra file so that cat can be used to pass special chars such as "`" which is used in the avahi daemon
  usersFile = pkgs.writeText "users" (concatStringsSep "\n" (map serializedUser users));
in

{
  require = [
    options

    # config.system.activationScripts
    ../system/activate-configuration.nix
  ];

  system = {
    activationScripts = {

      users = fullDepEntry ''
        cat ${usersFile} | while true; do
            read name || break
            read description
            read uid
            read group
            read extraGroups
            read home
            read shell
            read createHome

            if ! curEnt=$(getent passwd "$name"); then
                echo "creating user $name..."
                useradd --system \
                    "$name" \
                    --comment "$description" \
                    ''${uid:+--uid $uid} \
                    --gid "$group" \
                    --groups "$extraGroups" \
                    --home "$home" \
                    --shell "$shell" \
                    ''${createHome:+--create-home}
            else
                #echo "updating user $name..."
                oldIFS="$IFS"; IFS=:; set -- $curEnt; IFS="$oldIFS"
                prevUid=$3
                prevHome=$6
                # Don't change the UID if it's the same, otherwise usermod
                # will complain.
                if test "$prevUid" = "$uid"; then unset uid; fi
                # Don't change the home directory if it's the same to prevent
                # unnecessary warnings about logged in users.
                if test "$prevHome" = "$home"; then unset home; fi
                usermod \
                    "$name" \
                    --comment "$description" \
                    ''${uid:+--uid $uid} \
                    --gid "$group" \
                    --groups "$extraGroups" \
                    ''${home:+--home "$home"} \
                    --shell "$shell"
            fi
        done
      '' [ "groups" ];

      groups = fullDepEntry ''
        while true; do
            read name || break
            read gid

            if ! curEnt=$(getent group "$name"); then
                echo "creating group $name..."
                groupadd --system \
                    "$name" \
                    ''${gid:+--gid $gid}
            else
                #echo "updating group $name..."
                oldIFS="$IFS"; IFS=:; set -- $curEnt; IFS="$oldIFS"
                prevGid=$3
                if test -n "$gid" -a "$prevGid" != "$gid"; then
                    groupmod "$name" --gid $gid
                fi
            fi
        done <<EndOfGroupList
        ${concatStringsSep "\n" (map serializedGroup groups)}
        EndOfGroupList
      '' [ "rootPasswd" "binsh" "etc" "var" ];

    };
  };
}
