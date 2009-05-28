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
}
