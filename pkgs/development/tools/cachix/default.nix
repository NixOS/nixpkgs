{ haskellPackages, haskell, boost, nix }:

# justStaticExecutables is needed due to https://github.com/NixOS/nix/issues/2990
haskell.lib.justStaticExecutables (haskellPackages.extend (self: super: {
    # profiling is disabled to allow C++/C mess to work, which is fixed in GHC 8.8
    cachix = haskell.lib.disableLibraryProfiling (super.callPackage ./cachix.nix {inherit boost nix;});
    cachix-api = super.callPackage ./cachix-api.nix {};
    nix-narinfo = super.callPackage ./nix-narinfo.nix {};
})).cachix