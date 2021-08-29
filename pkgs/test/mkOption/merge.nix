let
  pkgs = import ../../.. {};
  config = import ./declare.nix;

  # Define the handler of unbound options.
  noOption = name: values:
    builtins.trace "Attribute named '${name}' does not match any option declaration." values;
in
  with (pkgs.lib);

  finalReferenceOptionSets
    (mergeOptionSets noOption)
    pkgs
    # List of main configurations.
    [ config.configB config.configC ]
