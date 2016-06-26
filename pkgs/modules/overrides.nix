{ config, lib, pkgs, ... }:

with lib;

let
  isConfig = x:
    builtins.isAttrs x || builtins.isFunction x;
  configType = mkOptionType {
    name = "nixpkgs config";
    check = traceValIfNot isConfig;
  };
in

{
  options = {
    packageOverrides = mkOption {
        type = configType;
        description = "Package overrides";
    };
  };
}
