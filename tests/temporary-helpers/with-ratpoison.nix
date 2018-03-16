# an example helper to start ratpoison so that there is some window management
#
# passes the arguments to with-x.nix
# also defines waitWindow that waits until the window list contains a line
#   matching the given regular expression (case-insensitive)
args@{ pkgs ? import ../.. {}, ... }:
pkgs.makeSetupHook {
  deps = [pkgs.ratpoison];
  substitutions = {
    inherit (pkgs) ratpoison;
    withX = (import ./with-x.nix args);
  };
} ./ratpoison.sh
