{
  lib,
  symlinkJoin,
  unwrapped,
  selector,
  pkgs,
}:
let
  mods = if lib.isFunction selector then selector pkgs else selector;
in
symlinkJoin {
  name = unwrapped.pname + "-with-mods-" + unwrapped.version;

  paths = [ unwrapped ] ++ mods;
}
