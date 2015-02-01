{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nginx;
  nginx = cfg.package;
  configFile = pkgs.writeText "nginx.conf" ''
    user ${cfg.user} ${cfg.group};
    daemon off;
    ${cfg.config}
    ${optionalString (cfg.httpConfig != "") ''
    http {
      ${cfg.httpConfig}
    }
    ''}
    ${cfg.appendConfig}
  '';
in

{
  options = {
    services.nginx = {
      enable = mkOption {
        default = false;
        description = "
          Enable the nginx Web Server.
        ";
      };

      package = mkOption {
        default = pkgs.nginx;
        type = types.package;
        description = "
          Nginx package to use.
        ";
      };

      config = mkOption {
        default = "events {}";
        description = "
          Verbatim nginx.conf configuration.
        ";
      };

      appendConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Configuration lines appended to the generated Nginx
          configuration file. Commonly used by different modules
          providing http snippets. <option>appendConfig</option>
          can be specified more than once and it's value will be
          concatenated (contrary to <option>config</option> which
          can be set only once).
        '';
      };

      httpConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Configuration lines to be appended inside of the http {} block.";
      };

      stateDir = mkOption {
        default = config.resources.dataContainers.nginx.path;
        description = "
          Directory holding all state for nginx to run.
        ";
      };

      user = mkOption {
        default = "nginx";
        description = "User account under which nginx runs.";
      };

      group = mkOption {
        default = "nginx";
        description = "Group account under which nginx runs.";
      };

    };

  };

  config = mkIf cfg.enable {
    # TODO: test user supplied config file pases syntax test

    sal.services.nginx = {
      inherit (cfg) user group;
      description = "Nginx Web Server";
      platforms = nginx.meta.platforms;

      requires = {
        networking = true;
        dataContainers = ["nginx"];
      };

      path = [ nginx ];
      preStart.script =''
        mkdir -p ${cfg.stateDir}/logs
      '';

      start.command = "${nginx}/bin/nginx -c ${configFile} -p ${cfg.stateDir}";
    };

    resources.dataContainers.nginx = {
      type = "spool";
      mode = "700";
      inherit (cfg) user group;
    };

    users.extraUsers = optionalAttrs (cfg.user == "nginx") (singleton
      { name = "nginx";
        group = cfg.group;
        uid = config.ids.uids.nginx;
      });

    users.extraGroups = optionalAttrs (cfg.group == "nginx") (singleton
      { name = "nginx";
        gid = config.ids.gids.nginx;
      });
  };
}
