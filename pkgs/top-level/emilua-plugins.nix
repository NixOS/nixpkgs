{lib, newScope, pkgs, config }:

emilua:
  (lib.makeScope newScope (self: {
    inherit emilua;
  }))
