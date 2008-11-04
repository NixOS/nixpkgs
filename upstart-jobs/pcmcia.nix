pkgs: config:

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
  ifEnable = arg:
    if config.hardware.pcmcia.enable then arg
    else if builtins.isList arg then []
    else if builtins.isAttrs arg then {}
    else null;

  pcmciaUtils = pkgs.pcmciaUtils.passthru.function {
    inherit (config.hardware.pcmcia) firmware config;
  };
in

{
  require = options;

  boot = {
    kernelModules = ifEnable [ "pcmcia" ];
  };

  services = {
    udev = {
      addUdevPkgs = ifEnable [ pcmciaUtils ];
    };
  };

  environment = {
    extraPackages = ifEnable [ pcmciaUtils ];
  };
}
