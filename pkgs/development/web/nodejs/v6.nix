{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool
, callPackage
, darwin ? null
}@args:

let
  inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;

in import ./nodejs.nix (args // rec {
  version = "6.3.1";
  sha256 = "06ran2ccfxkwyk6w4wikd7qws286952lbx93pqaygmbh9f0q9rbg";
  extraBuildInputs = stdenv.lib.optionals stdenv.isDarwin
    [ CoreServices ApplicationServices ];
  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i -e "s|tr1/type_traits|type_traits|g" \
      -e "s|std::tr1|std|" src/util.h
  '';
})
