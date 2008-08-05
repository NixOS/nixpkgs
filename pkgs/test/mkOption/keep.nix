let
  pkgs = import ../../top-level/all-packages.nix {};
  config = import ./declare.nix;
in
  with (pkgs.lib);

  finalReferenceOptionSets
    filterOptionSets
    pkgs
    # List of main configurations.
    [ config.configB config.configC ]
