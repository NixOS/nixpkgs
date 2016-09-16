{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool
, callPackage
, darwin ? null
}@args:

let
  inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;

in import ./nodejs.nix (args // rec {
  version = "6.5.0";
  sha256 = "140jvdfps7fblz2qip4qc8b1fzv1krph2v3vf3dj7iv4j5m0bwnx";
  extraBuildInputs = stdenv.lib.optionals stdenv.isDarwin
    [ CoreServices ApplicationServices ];
  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i -e "s|tr1/type_traits|type_traits|g" \
      -e "s|std::tr1|std|" src/util.h
  '';
})
