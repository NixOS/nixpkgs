{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption;

  options = {
    services = {
      atd = {

        enable = mkOption {
          default = true;
          description = ''
            Whether to enable the `at' daemon, a command scheduler.
          '';
        };

        allowEveryone = mkOption {
          default = false;
          description = ''
            Whether to make /var/spool/at{jobs,spool} writeable 
            by everyone (and sticky).  This is normally not needed since
            the `at' commands are setuid/setgid `atd'.
          '';
        };
      };

    };
  };
in

###### implementation
let
  cfg = config.services.atd;
  inherit (pkgs.lib) mkIf;
  inherit (pkgs) at;

  user = {
    name = "atd";
    uid = (import ../system/ids.nix).uids.atd;
    description = "atd user";
    home = "/var/empty";
  };

  group = {
    name = "atd";
    gid = (import ../system/ids.nix).gids.atd;
  };

  job = ''
description "at daemon (atd)"

start on startup
stop on shutdown

start script
   # Snippets taken and adapted from the original `install' rule of
   # the makefile.

   # We assume these values are those actually used in Nixpkgs for
   # `at'.
   spooldir=/var/spool/atspool
   jobdir=/var/spool/atjobs
   etcdir=/etc/at

   for dir in "$spooldir" "$jobdir" "$etcdir"
   do
     if [ ! -d "$dir" ]
     then
         mkdir -p "$dir" && chown atd:atd "$dir"
     fi
   done
   chmod 1770 "$spooldir" "$jobdir"
   ${if cfg.allowEveryone then ''chmod a+rwxt "$spooldir" "$jobdir" '' else ""}
   if [ ! -f "$etcdir"/at.deny ]
   then
       touch "$etcdir"/at.deny && \
       chown root:atd "$etcdir"/at.deny && \
       chmod 640 "$etcdir"/at.deny
   fi
   if [ ! -f "$jobdir"/.SEQ ]
   then
       touch "$jobdir"/.SEQ && \
       chown atd:atd "$jobdir"/.SEQ && \
       chmod 600 "$jobdir"/.SEQ
   fi
end script

respawn ${at}/sbin/atd
'';
in

mkIf cfg.enable {
  require = [
    options

    # config.services.extraJobs
    ../upstart-jobs/default.nix

    # config.environment.etc
    ../etc/default.nix

    # users.*
    ../system/users-groups.nix

    # ? # config.environment.extraPackages
    # ? # config.security.extraSetuidPrograms
  ];

  security = {
    setuidOwners = map (program: {
        inherit program;
        owner = "atd";
        group = "atd";
        setuid = true;
        setgid = true;
      }) [ "at" "atq" "atrm" ];
  };

  environment = {
    extraPackages = [ at ];

    etc = [{
      source = ../etc/pam.d/atd;
      target = "pam.d/atd";
    }];
  };

  users = {
    extraUsers = [user];
    extraGroups = [group];
  };

  services = {
    extraJobs = [{
      name = "atd";
      inherit job;
    }];
  };
}
