{ lib, haskellPackages, haskell }:

(haskellPackages.override (old: {
  overrides = lib.composeExtensions (old.overrides or (_: _: {})) (self: super: {
    cachix = haskell.lib.justStaticExecutables (super.callPackage ./cachix.nix {});
    cachix-api = super.callPackage ./cachix-api.nix {};
  });
})).cachix
