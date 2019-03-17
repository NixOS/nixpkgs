{ haskellPackages, haskell }:

(haskellPackages.extend (self: super: {
  cachix = haskell.lib.justStaticExecutables (super.callPackage ./cachix.nix {});
  cachix-api = super.callPackage ./cachix-api.nix {};
})).cachix
