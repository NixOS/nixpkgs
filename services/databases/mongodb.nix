{ config, lib, pkgs, ... }:

with lib;

let

  b2s = x: if x then "true" else "false";

  pm = config.sal.processManager;
  cfg = config.services.mongodb;
  forking = pm.supports.fork && pm.supports.syslog;

  mongodb = cfg.package;

  mongoCnf = pkgs.writeText "mongodb.conf"
  ''
    bind_ip = ${cfg.bind_ip}
    ${optionalString cfg.quiet "quiet = true"}
    dbpath = ${cfg.dbpath}
    syslog = ${b2s forking}
    fork = ${b2s forking}
    pidfilepath = ${cfg.pidFile}
    ${optionalString (cfg.replSetName != "") "replSet = ${cfg.replSetName}"}
    ${cfg.extraConfig}
  '';

in

{

  ###### interface

  options = {

    services.mongodb = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to enable mongodb service.";
      };

      package = mkOption {
        default = pkgs.mongodb;
        type = types.package;
        description = "
          Which MongoDB derivation to use.
        ";
      };

      bind_ip = mkOption {
        default = "127.0.0.1";
        description = "IP to bind to";
      };

      quiet = mkOption {
        default = false;
        description = "quieter output";
      };

      dbpath = mkOption {
        default = config.resources.dataContainers.mongodb.path;
        description = "Location where MongoDB stores its files";
      };

      pidFile = mkOption {
        default = "${config.resources.dataContainers.mongodb-state.path}/mongodb.pid";
        description = "Location of MongoDB pid file";
      };

      replSetName = mkOption {
        default = "";
        description = ''
          If this instance is part of a replica set, set its name here.
          Otherwise, leave empty to run as single node.
        '';
      };

      extraConfig = mkOption {
        default = "";
        example = ''
          nojournal = true
        '';
        description = "MongoDB extra configuration";
      };
    };

  };


  ###### implementation

  config = mkIf (cfg.enable) {
    sal.services.mongodb = {
      description = "MongoDB server";
      platforms = pkgs.mongodb.meta.platforms;
      type = "${if forking then "forking" else "simple"}";
      start.command = "${mongodb}/bin/mongod --quiet --config ${mongoCnf}";

      requires = {
        networking = true;
        dataContainers = ["mongodb" "mongodb-state"];
        port = [ 27017 ];
      };

      pidFile = cfg.pidFile;
      user = "mongodb";
    };

    resources.dataContainers.mongodb = {
      type = "db";
      mode = "700";
      user = "mongodb";
    };

    resources.dataContainers.mongodb-state = {
      name = "mongodb";
      type = "run";
      mode = "755";
      user = "mongodb";
    };

    environment.systemPackages = [ mongodb ];

    users.extraUsers.mongodb = {
      name = "mongodb";
      uid = config.ids.uids.mongodb;
      description = "MongoDB server user";
    };
  };

}
