{
  lib,
  newScope,
  pkgs,
  config,
}:

emilua:
(lib.makeScope newScope (self: {
  inherit emilua;
  beast = self.callPackage ../development/emilua-plugins/beast { };
  qt5 = self.callPackage ../development/emilua-plugins/qt5 { };
  qt6 = self.callPackage ../development/emilua-plugins/qt6 { };
}))
