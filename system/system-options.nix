# this file contains all extendable options originally defined in system.nix
# TODO: split it to make it readable.
{pkgs, config, ...}:

with pkgs.lib;

###### interface
let

  option = {
    system = {
      build = mkOption {
        default = {};
        description = ''
          Attribute set of derivations used to setup the system.
        '';
      };

      shell = mkOption {
        default = "/var/run/current-system/sw/bin/bash";
        description = ''
          This option defines the path to the Bash shell.  It should
          generally not be overriden.
        '';
        merge = list:
          assert list != [] && builtins.tail list == [];
          builtins.head list;
      };

    };
  };
in

###### implementation
{
  require = [
    option

    # config.system.activationScripts
    # ../system/activate-configuration.nix
  ];

  system = {
    build = {
      binsh = pkgs.bashInteractive;
    };
  };
}
