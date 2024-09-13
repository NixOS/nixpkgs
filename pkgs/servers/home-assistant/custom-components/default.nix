{
  callPackage,
  lib,
  ...
}:

import ../autocalling-package-set.nix {
  inherit callPackage lib;
  baseDirectory = ./.;
}
