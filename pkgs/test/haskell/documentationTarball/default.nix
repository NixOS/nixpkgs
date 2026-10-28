{ pkgs, haskellPackages }:

let
  drv = haskellPackages.random;
  docs = pkgs.haskell.lib.compose.documentationTarball drv;

in
pkgs.runCommand "test haskell.lib.compose.documentationTarball"
  {
    meta = {
      inherit (docs.meta) platforms;
    };
  }
  ''
    tar xvzf "${docs}/${drv.name}-docs.tar.gz"

    # Check for Haddock html
    find "${drv.name}-docs" | grep -q "System-Random.html"

    # Check for source html
    find "${drv.name}-docs" | grep -q  "src/System.Random.html"

    touch "$out"
  ''
