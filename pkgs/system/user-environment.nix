# Given a system identifier, this function returns a derivation of a
# user environment, i.e., a set of symbolic links to `activated'
# packages.  The resulting package is typically passed to the
# `nix-switch' command in order to actually activate it.

{system}: let {
  # All activated packages.
  pkgs = (import ./all-packages.nix) {system = system};

  # The packages selection for inclusion in the user environment.
  # This list should be generated automatically by a package
  # management user interface.
  selectedPkgs = [
    pkgs.subversion
    pkgs.pan
    pkgs.sylpheed
    pkgs.firebird
    pkgs.MPlayer
    pkgs.MPlayerPlugin
    pkgs.gqview
  ];

  # Create a user environment.
  body = derivation { 
    name = "user-environment";
    system = system;
    builder = ./populate-linkdirs.pl;
    dirs = selectedPkgs;
  };
}
