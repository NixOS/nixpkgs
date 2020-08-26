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
  version = "4.2.8";
  sha256 = "13yvhi1258skdni00bh6ph609whqsmhiimhyqy1gs2liwdvh5278";
  patches =
    [ ./forget-build-dependencies-4-2.patch ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view-4-2.patch ];
}
