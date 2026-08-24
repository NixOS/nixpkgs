{ callPackage }:

rec {
  buildMod = callPackage ./builder.nix {
    type = "mod";
  };

  buildSoundPack = callPackage ./builder.nix {
    type = "soundpack";
  };

  buildTileSet = callPackage ./builder.nix {
    type = "tileset";
  };

  wrapCDDA = callPackage ./wrapper.nix { };

  # Required to fix `pkgs` and `withMods` attrs after applying `overrideAttrs`.
  #
  # Example:
  #     let
  #       myBuild = cataclysmDDA.jenkins.latest.tiles.overrideAttrs (_: {
  #         x = "hello";
  #       });
  #
  #       # This refers to the derivation before overriding! So, `badExample.x` is not accessible.
  #       badExample = myBuild.withMods (_: []);
  #
  #       # `myBuild` is correctly referred by `withMods` and `goodExample.x` is accessible.
  #       goodExample = let
  #         inherit (cataclysmDDA) attachPkgs pkgs;
  #       in
  #       (attachPkgs pkgs myBuild).withMods (_: []);
  #     in
  #     goodExample.x  # returns "hello"
  attachPkgs =
    pkgs: super:
    let
      self = super.overrideAttrs (old: {
        passthru = old.passthru // {
          pkgs = pkgs.override { build = self; };
          withMods = wrapCDDA self;
        };
      });
    in
    self;
}
