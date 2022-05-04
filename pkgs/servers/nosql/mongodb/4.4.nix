{ stdenv, callPackage, lib, sasl, boost, Security, CoreFoundation, cctools }:

let
  buildMongoDB = callPackage ./mongodb.nix {
    inherit sasl boost Security CoreFoundation cctools;
  };
in
buildMongoDB {
  version = "4.4.13";
  sha256 = "sha256-ebg3R6P+tjRvizDzsl7mZzhTfqIaRJPfHBu0IfRvtS8=";
  patches = [
    ./forget-build-dependencies-4-4.patch
  ] ++ lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view-4-4.patch ];
}
