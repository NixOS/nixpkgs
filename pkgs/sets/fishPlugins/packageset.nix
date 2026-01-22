{
  lib,
  newScope,
  config,
}:

lib.makeScope newScope (
  self:
  (lib.pipe ./. [
    builtins.readDir
    (lib.filterAttrs (name: _: lib.pathIsRegularFile ./${name}/package.nix))
    (builtins.mapAttrs (name: _: self.callPackage ./${name}/package.nix { }))
  ])
  // lib.optionalAttrs config.allowAliases {
    autopair-fish = self.autopair; # Added 2023-03-10
  }
)
