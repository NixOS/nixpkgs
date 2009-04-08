{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    users = {
      ldap = {

        enable = mkOption {
          default = false;
          description = "
            Whether to enable authentication against an LDAP server.
          ";
        };

        server = mkOption {
          example = "ldap://ldap.example.org/";
          description = "
            The URL of the LDAP server.
          ";
        };

        base = mkOption {
          example = "dc=example,dc=org";
          description = "
            The distinguished name of the search base.
          ";
        };

        useTLS = mkOption {
          default = false;
          description = "
            If enabled, use TLS (encryption) over an LDAP (port 389)
            connection.  The alternative is to specify an LDAPS server (port
            636) in <option>users.ldap.server</option> or to forego
            security.
          ";
        };

      };
    };
  };
in

###### implementation

mkIf config.users.ldap.enable {
  require = [
    options
  ];

  # LDAP configuration.
  environment = {
    etc = [

      # Careful: OpenLDAP seems to be very picky about the indentation of
      # this file.  Directives HAVE to start in the first column!
      { source = pkgs.writeText "ldap.conf" ''
        uri ${config.users.ldap.server}
        base ${config.users.ldap.base}
        
        ${
        if config.users.ldap.useTLS then ''
        ssl start_tls
        tls_checkpeer no
        '' else ""
        }
      '';
        target = "ldap.conf";
      }
    ];
  };

}
