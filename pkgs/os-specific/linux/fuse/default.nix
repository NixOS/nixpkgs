{
  config,
  lib,
  callPackage,
  util-linux,
}:

let
  mkFuse =
    args:
    callPackage (import ./common.nix args) {
      inherit util-linux;
    };
in
{
  fuse_3 = mkFuse {
    version = "3.18.3";
    hash = "sha256-1LuXO7TU2MUP3OFx2khT1wQ3cNmrk87yXaE4V3F1BeA=";
  };
}
// lib.optionalAttrs config.allowAliases {
  fuse_2 = throw "fuse2 has been removed because it is deemed end of life and unmaintained since 2019.";
}
