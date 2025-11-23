# This file turns the pkgs/by-name directory (see its README.md for more info) into an overlay that adds all the defined packages.
# No validity checks are done here,
# instead this file is optimised for performance,
# and validity checks are done by CI on PRs.

# Type: Path -> Overlay
baseDirectory:
let
  # Because of Nix's import-value cache, importing lib is free
  lib = import ../../lib;

  inherit (builtins)
    readDir
    ;

  inherit (lib.attrsets)
    mapAttrs
    mapAttrsToList
    mergeAttrsList
    ;

  # Package directories for a single shard
  # Type: String -> String -> AttrsOf Path
  namesForShard =
    shard: type:
    if type != "directory" then
      # Ignore all non-directories. Technically only README.md is allowed as a file in the base directory, so we could alternatively:
      # - Assume that README.md is the only file and change the condition to `shard == "README.md"` for a minor performance improvement.
      #   This would however cause very poor error messages if there's other files.
      # - Ensure that README.md is the only file, throwing a better error message if that's not the case.
      #   However this would make for a poor code architecture, because one type of error would have to be duplicated in the validity checks and here.
      # Additionally in either of those alternatives, we would have to duplicate the hardcoding of "README.md"
      { }
    else
      mapAttrs (name: _: baseDirectory + "/${shard}/${name}") (readDir (baseDirectory + "/${shard}"));

  # The attribute set mapping names to the package files defining them
  # This is defined up here in order to allow reuse of the value (it's kind of expensive to compute)
  # if the overlay has to be applied multiple times
  packageDirectories = mergeAttrsList (mapAttrsToList namesForShard (readDir baseDirectory));
in
final: prev:
mapAttrs (
  _: packageDirectory:
  if lib.pathExists (packageDirectory + "/pins.nix") then
    final.callPackage (packageDirectory + "/package.nix") (
      lib.removeAttrs (final.callPackage (packageDirectory + "/pins.nix") { }) [
        "override"
        "overrideDerivation"
      ]
    )
  else
    final.callPackage (packageDirectory + "/package.nix") { }
) packageDirectories
