# Qt packages set.
#
# Attributes in this file are packages requiring Qt and will be made available
# for every Qt version. Qt applications are called from `all-packages.nix` via
# this file.

{ lib
, pkgs
, qt6
}:

(lib.makeScope pkgs.newScope ( self:

let
  libsForQt6 = self;
  callPackage = self.callPackage;
in

(qt6 // {
  # LIBRARIES

  quazip = callPackage ../development/libraries/quazip { };
})))
