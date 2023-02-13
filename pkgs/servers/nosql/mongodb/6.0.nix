{ stdenv, callPackage, lib, sasl, boost, Security, CoreFoundation, cctools }:

let
  buildMongoDB = callPackage ./mongodb.nix {
    inherit sasl boost Security CoreFoundation cctools stdenv;
  };
in
buildMongoDB {
  version = "6.0.1";
  sha256 = "sha256-3LdyPHj2t7JskCJh6flCYl6qjfAbRXHsi+19L+0O2Zs=";
  patches = [ ];
}
