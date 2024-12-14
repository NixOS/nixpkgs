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
  bech32 = self.callPackage ../development/emilua-plugins/bech32 { };
  botan = self.callPackage ../development/emilua-plugins/botan {
    inherit (pkgs) botan3;
  };
  qt5 = self.callPackage ../development/emilua-plugins/qt5 { };
  qt6 = self.callPackage ../development/emilua-plugins/qt6 { };
  secp256k1 = self.callPackage ../development/emilua-plugins/secp256k1 {
    inherit (pkgs) secp256k1;
  };
  tdlib = self.callPackage ../development/emilua-plugins/tdlib { };
  this-thread = self.callPackage ../development/emilua-plugins/this-thread { };
}))
