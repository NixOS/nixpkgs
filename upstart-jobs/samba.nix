{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf mkAlways;

  options = {
    services = {
      samba = {

        enable = mkOption {
          default = false;
          description = "
            Whether to enable the samba server. (to communicate with, and provide windows shares)
            use start / stop samba-control to start/stop all daemons.
            smbd and nmbd are not shutdown correctly yet. so just pkill them and restart those jobs.
          ";
        };

        syncPasswordsByPam = mkOption {
          default = false;
          description = "
            enabling this will add a line directly after pam_unix.so.
            Whenever a password is changed the samba password will be updated as well.
            However you still yave to add the samba password once using smbpasswd -a user
            If you don't want to maintain an extra pwd database you still can send plain text
            passwords which is not secure.
          ";
        };

        extraConfig = mkOption {
          default = ''
            # [global] continuing global section here, section is started by nix to set pids etc

              smb passwd file = /etc/samba/passwd

              # is this useful ?
              domain master = auto

              encrypt passwords = Yes
              client plaintext auth = No

              # yes: if you use this you probably also want to enable syncPasswordsByPam
              # no: You can still use the pam password database. However
              # passwords will be sent plain text on network (discouraged)

              workgroup = Users
              server string = %h
              comment = Samba
              log file = /var/log/samba/log.%m
              log level = 10
              max log size = 50000
              security = user
              
              client lanman auth = Yes
              dns proxy = no
              invalid users = root
              passdb backend = tdbsam
              passwd program = /usr/bin/passwd %u

            ### end [ global ] section
            
             
            # Un-comment the following (and tweak the other settings below to suit)
            # to enable the default home directory shares.  This will share each
            # user's home directory as \\server\username
            ;[homes]
            ;   comment = Home Directories
            ;   browseable = no
            ;   writable = no

            # File creation mask is set to 0700 for security reasons. If you want to
            # create files with group=rw permissions, set next parameter to 0775.
            ;   create mask = 0700

            #  this directory and user is created automatically for you by nixos
            ;[default]
            ;  path = /home/smbd
            ;  read only = no
            ;  guest ok = yes
              
            # this directory and user is created automatically for you by nixos
            ;[default]
            ;  path = /home/smbd
            ;  read only = no
            ;  guest ok = yes
            
            # additional share example
            ;[raidbackup]
            ;  path = /home/raidbackup/files
            ;  read only = no
            ;  guest ok = no
            ;  available = yes
            ;  browseable = yes
            ;  public = yes
            ;  valid users = raidbackup
            ;  comment = Raid backup Files
          '';

          description = "
            additional global section and extra section lines go in here.
          ";
        };

        configFile = mkOption {
          description = "
            internal use to pass filepath to samba pam module
          ";
        };
      };
    };
  };
in

###### implementation

let

  cfg = config.services.samba;
  
  user = "smbguest";
  group = "smbguest";


  logDir = "/var/log/samba";
  privateDir = "/var/samba/private";
 
  inherit (pkgs) samba;

  setupScript = ''
    mkdir -p /var/lock

    if ! test -d /home/smbd ; then
      mkdir -p /home/smbd
      chown ${user} /home/smbd
      chmod a+rwx /home/smbd
    fi

    if ! test -d /var/samba ; then
      mkdir -p /var/samba/locks /var/samba/cores/nmbd  /var/samba/cores/smbd /var/samba/cores/winbindd
    fi

    passwdFile="$(sed -n 's/^.*smb[ ]\+passwd[ ]\+file[ ]\+=[ ]\+\(.*\)/\1/p' /nix/store/nnmrqalldfv2vkwy6qpg340rv7w34lmp-smb.conf)"
    if [ -n "$passwdFile" ]; then
      echo 'INFO: creating directory containing passwd file'
      mkdir -p "$(dirname "$passwdFile")"
    fi

    mkdir -p ${logDir}
    mkdir -p ${privateDir}
  '';

  configFile = pkgs.writeText "smb.conf" ''
    [ global ]
      log file = ${logDir}/log.%m
      private dir = ${privateDir}

      ${if cfg.syncPasswordsByPam then "pam password change = true" else "" /* does this make sense ? */ }


    ${cfg.extraConfig}";
  '';

  daemonJob = appName : args :
    {
      name = "samba-${appName}";
      job = ''

        description "Samba Service daemon ${appName}"

        start on samba-control/started
        stop on samba-control/stop

        respawn ${samba}/sbin/${appName} ${args}
      '';
    };

in


mkIf config.services.samba.enable {
  require = [
    options
  ];

  users = {
    extraUsers = [
      { name = user;
        description = "Samba service user";
        group = group;
      }
    ];
    
    extraGroups = [
      { name = group;
      }
    ];
  };

  # always provide a smb.conf to shut up programs like smbclient and smbspool.
  environment = {
    etc = mkAlways [{
      source = if cfg.enable then configFile else pkgs.writeText "smb-dummy.conf" "# samba is disabled. Purpose see samba expression in nixpkgs";
      target = "samba/smb.conf";
      }];
  };

  services = {

    extraJobs = [
    { name = "samba-control"; # start this dummy job to start the real samba daemons nmbd, smbd, winbindd
      job = ''
        description "samba job starting/stopping the real samba jobs";

        start on network-interfaces/started
        stop on network-interfaces/stop

        start script
        ${setupScript}
        end script

        respawn sleep 1000000 # !!! hack

        # put the store path here so that daemons are restarted when configuration changes
        # config is ${configFile}
      '';
    }
    # add -S to get debugging output on stdout
    # config directory is passed by configure at compilation time
    ( daemonJob "nmbd" " -i -F" ) # nmbd says "standard input is not a socket, assuming -D option", but using -i makes it stay in foreground (?)
    ( daemonJob "smbd" " -i -F" ) # dito
    ( daemonJob "winbindd" " -F" )
    ];
  };
}
