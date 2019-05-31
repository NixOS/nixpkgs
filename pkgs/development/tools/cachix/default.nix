{ haskellPackages, haskell }:

(haskell.lib.doDistribute haskellPackages.cachix).bin
