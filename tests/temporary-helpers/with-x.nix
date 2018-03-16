# an example helper to run X inside the build sandbox
#
# display is the number of X DISPLAY; shouldn't matter inside the sandbox
# dpi and geometry are used to configure the virtual display
{ pkgs ? import ../../default.nix {}
, display ? 27, dpi ? 150, geometry ? "800x600" }:
pkgs.makeSetupHook {
  substitutions = {
    inherit (pkgs) xdummy;
    inherit (pkgs.xorg) xrandr xrdb;
    inherit display geometry dpi;
  };
} ./x.sh
