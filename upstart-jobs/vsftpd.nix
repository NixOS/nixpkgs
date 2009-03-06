{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      vsftpd = {
        enable = mkOption {
          default = false;
          description = "
            Whether to enable the vsftpd FTP server.
          ";
        };
        
        anonymousUser = mkOption {
          default = false;
          description = "
            Whether to enable the anonymous FTP user.
          ";
        };

        writeEnable = mkOption {
          default = false;
          description = "
            Whether any write activity is permitted to users.
          ";
        };

        anonymousUploadEnable = mkOption {
          default = false;
          description = "
            Whether any uploads are permitted to anonymous users.
          ";
        };

        anonymousMkdirEnable = mkOption {
          default = false;
          description = "
            Whether mkdir is permitted to anonymous users.
          ";
        };
      };
    };
  };
in

###### implementation

let 

  inherit (config.services.vsftpd) anonymousUser writeEnable anonymousUploadEnable anonymousMkdirEnable;
  inherit (pkgs) vsftpd;

  yesNoOption = p : name :
    "${name}=${if p then "YES" else "NO"}";

in

mkIf config.services.vsftpd.enable {
  require = [
    options
  ];

  users = {
    extraUsers = [
        { name = "vsftpd";
          uid = (import ../system/ids.nix).uids.vsftpd;
          description = "VSFTPD user";
          home = "/homeless-shelter";
        }
      ] ++ pkgs.lib.optional anonymousUser
        { name = "ftp";
          uid = (import ../system/ids.nix).uids.ftp;
          group = "ftp";
          description = "Anonymous ftp user";
          home = "/home/ftp";
        };

    extraGroups = [
      { name = "ftp";
        gid = (import ../system/ids.nix).gids.ftp;
      }
    ];
      
  };

  services = {
    extraJobs = [{
      name = "vsftpd";

      job = ''
        description "vsftpd server"

        start on network-interfaces/started
        stop on network-interfaces/stop

        start script
        cat > /etc/vsftpd.conf <<EOF
        ${yesNoOption anonymousUser "anonymous_enable"}
        ${yesNoOption writeEnable "write_enable"}
        ${yesNoOption anonymousUploadEnable "anon_upload_enable"}
        ${yesNoOption anonymousMkdirEnable "anon_mkdir_write_enable"}
        background=NO
        listen=YES
        nopriv_user=vsftpd
        secure_chroot_dir=/var/ftp/empty
        EOF

        mkdir -p /home/ftp &&
        chown -R ftp:ftp /home/ftp
        end script

        respawn ${vsftpd}/sbin/vsftpd /etc/vsftpd.conf
      '';
      
    }];
  };
}
