{ haskellPackages, haskell }:

haskell.lib.justStaticExecutables (haskellPackages.extend (self: super: {
    cachix = haskell.lib.doDistribute (self.cachix_0_2_1 or self.cachix);
    cachix-api = self.cachix-api_0_2_1 or self.cachix-api;
})).cachix
