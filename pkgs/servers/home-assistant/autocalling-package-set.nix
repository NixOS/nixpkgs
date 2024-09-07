{
  lib,
  callPackage,
  baseDirectory,
}:

let
  inherit (lib)
    filterAttrs
    mapAttrs'
    nameValuePair
    ;

  inherit (builtins)
    readDir
    ;

  toPackageAttribute =
    dir: type: nameValuePair dir (callPackage (baseDirectory + "/${dir}/default.nix") { });
in
mapAttrs' toPackageAttribute (filterAttrs (_: type: type == "directory") (readDir baseDirectory))
