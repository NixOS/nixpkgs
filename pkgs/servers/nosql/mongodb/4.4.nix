{ stdenv, callPackage, lib, sasl, boost, Security, CoreFoundation, cctools }:

let
  buildMongoDB = callPackage ./mongodb.nix {
    inherit sasl boost Security CoreFoundation cctools;
  };
in
buildMongoDB {
  version = "4.4.10";
  sha256 = "1rn9w3wwb2kbixqx39zb7cczzw5qjbh7d9yhlbivrs0f9bywl8nx";
  patches = [
    ./forget-build-dependencies-4-4.patch
  ] ++ lib.optionals stdenv.isDarwin [ ./asio-no-experimental-string-view-4-4.patch ];
}
