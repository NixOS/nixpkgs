{ haskellPackages, haskell }:

(haskellPackages.override {
  overrides = self: super: {
    cachix = haskell.lib.justStaticExecutables (super.callPackage ./cachix.nix {});
    cachix-api = super.callPackage ./cachix-api.nix {};
  };
}).cachix
