{ formats, hello }:

{ lib, ... }:
let
  format = formats.ini { };
in
{
  options.settings = lib.mkOption {
    type = format.type;
    default = { };
  };
  options.package = lib.mkOption {
    type = lib.types.package;
    default = hello;
  };
}
