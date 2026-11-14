{ formats }:

{ config, lib, ... }:
let
  format = formats.ini { };
in
{
  options.settings = lib.mkOption {
    type = lib.types.submodule { freeformType = format.type; };
    default = { };
  };
  options.extraConfig = lib.mkOption {
    type = lib.types.lines;
    default = "";
  };
  config.portable.files = {
    "main.ini" = {
      inherit format;
      value = config.settings;
    };
    "extra.conf" = {
      enable = config.extraConfig != "";
      text = config.extraConfig;
    };
  };
}
