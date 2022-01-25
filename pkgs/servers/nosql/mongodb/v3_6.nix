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
  version = "3.6.23";
  sha256 = "sha256-EJpIerW4zcGJvHfqJ65fG8yNsLRlUnRkvYfC+jkoFJ4=";
  patches = [ ./forget-build-dependencies.patch ]
    ++ lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view.patch ];
}
