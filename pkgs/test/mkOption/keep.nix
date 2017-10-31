let
  pkgs = import ../../.. {};
  config = import ./declare.nix;
in
  with (pkgs.lib);

  finalReferenceOptionSets
    filterOptionSets
    pkgs
    # List of main configurations.
    [ config.configB config.configC ]
