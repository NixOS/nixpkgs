{ stdenv, callPackage, lib, sasl, boost, Security, CoreFoundation, cctools }:

let
  buildMongoDB = callPackage ./mongodb.nix {
    inherit sasl;
    inherit boost;
    inherit Security;
    inherit CoreFoundation;
    inherit cctools;
  };
in buildMongoDB {
  version = "3.6.13";
  sha256 = "1mbvk4bmabrswjdm01jssxcygjpq5799zqyx901nsi12vlcymwg4";
  patches = [ ./forget-build-dependencies.patch ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view.patch ];
}
