{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool
, callPackage
, darwin ? null
}@args:

let
  inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;

in import ./nodejs.nix (args // rec {
  version = "6.6.0";
  sha256 = "0cqswab9idbz5kzj50fnalg1zrircmbn9qga0cr33lvjnv98a134";
  extraBuildInputs = stdenv.lib.optionals stdenv.isDarwin
    [ CoreServices ApplicationServices ];
  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i -e "s|tr1/type_traits|type_traits|g" \
      -e "s|std::tr1|std|" src/util.h
  '';
})
