{ pkgs, haskellPackages }:

let
  drv = haskellPackages.vector;
  docs = pkgs.haskell.lib.documentationTarball drv;

in pkgs.runCommand "test haskell.lib.documentationTarball" {
  meta = {
    inherit (docs.meta) platforms;
  };
} ''
  tar xvzf "${docs}/${drv.name}-docs.tar.gz"

  # Check for Haddock html
  find "${drv.name}-docs" | grep -q "Data-Vector.html"

  # Check for source html
  find "${drv.name}-docs" | grep -q  "src/Data.Vector.html"

  touch "$out"
''
