{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption
    mergeEnableOption mergeListOption;

  options = {
    hardware = {
      pcmcia = {
        enable = mkOption {
          default = false;
          merge = mergeEnableOption;
          description = ''
            Enable this option to support PCMCIA card.
          '';
        };

        firmware = mkOption {
          default = [];
          merge = mergeListOption;
          description = ''
            List of firmware used to handle specific PCMCIA card.
          '';
        };

        config = mkOption {
          default = null;
          description = ''
            Path to the configuration file which map the memory, irq
            and ports used by the PCMCIA hardware.
          '';
        };
      };
    };
  };
in

###### implementation
let
  inherit (pkgs.lib) mkIf;

  pcmciaUtils = pkgs.pcmciaUtils.passthru.function {
    inherit (config.hardware.pcmcia) firmware config;
  };
in


mkIf config.hardware.pcmcia.enable {
  require = [
    # (import ../upstart-jobs/udev.nix)
    # (import ?) # config.environment.extraPackages
    options
  ];

  boot = {
    kernelModules = [ "pcmcia" ];
  };

  services = {
    udev = {
      addUdevPkgs = [ pcmciaUtils ];
    };
  };

  environment = {
    extraPackages = [ pcmciaUtils ];
  };
}
