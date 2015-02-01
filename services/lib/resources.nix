{ config, lib, pkgs,  ... }:

with lib;

let
  gconfig = config;

  commonOptions = {
    description = mkOption {
      type = types.str;
      default = "";
      description = "Resource description.";
    };
  };

  dataContainerOptions = { name, config, ... }: {
    options = commonOptions // {

      name = mkOption {
        type = types.str;
        description = "Name of data container.";
      };

      type = mkOption {
        default = "lib";
        type = types.enum ["db" "lib" "log" "run" "spool"];
        description = "Type of data container.";
      };

      mode = mkOption {
        default = "600";
        type = types.str;
        description = "File mode for data container";
      };

      user = mkOption {
        default = "";
        type = types.str;
        description = "Data container user.";
      };

      group = mkOption {
        default = "";
        type = types.str;
        description = "Data container group.";
      };

      path = mkOption {
        type = types.path;
        description = "Path exposed for resources.";
      };

    };

    config = {
      name = mkDefault name;
      path = mkDefault (gconfig.resources.dataContainerMapping config);
    };
  };

  socketOptions = { name, config, ... }: {
    options = commonOptions // {
      name = mkOption {
        type = types.str;
        description = "Name of socket.";
      };

      listen = mkOption {
        type = types.str;
        example = "0.0.0.0:993";
        description = "Address or file where socket should listen.";
      };

      type = mkOption {
        type = types.enum ["inet" "inet6" "unix"];
        description = "Type of listening socket";
      };

      mode = mkOption {
        default = "600";
        type = types.str;
        description = "File mode for socker";
      };

      user = mkOption {
        default = "";
        type = types.str;
        description = "Socket owner user.";
      };

      group = mkOption {
        default = "";
        type = types.str;
        description = "Socket owner group.";
      };
    };

    config = {
      name = mkDefault name;
    };
  };


in {
  options = {
    resources.dataContainers = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = [ dataContainerOptions ];
      description = "Definition of data containers.";
    };

    resources.dataContainerMapping = mkOption {
      default = dc: "/var/${dc.type}/${dc.name}";
      description = "Mapping function for data containers that defines
        concrete paths where the data should be.";
    };

    resources.sockets = mkOption {
      default = {};
      type = types.attrsOf types.optionSet;
      options = [ socketOptions ];
      description = "Definition of socket resources.";
    };
  };

  config = {
    assertions = [];
  };
}
