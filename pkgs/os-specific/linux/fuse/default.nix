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
    version = "3.18.2";
    hash = "sha256-QArQMSStVxwUo6CgU2JlXBdFWjzlGXfZk1AVGLGeE70=";
  };
}
// lib.optionalAttrs config.allowAliases {
  fuse_2 = throw "fuse2 has been removed because it is deemed end of life and unmaintained since 2019.";
}
