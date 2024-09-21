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
  botan = self.callPackage ../development/emilua-plugins/botan {
    inherit (pkgs) botan3;
  };
  qt5 = self.callPackage ../development/emilua-plugins/qt5 { };
  qt6 = self.callPackage ../development/emilua-plugins/qt6 { };
}))
