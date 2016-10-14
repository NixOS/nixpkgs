{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool, fetchpatch
, callPackage
, darwin ? null
}@args:

let
  inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;

in import ./nodejs.nix (args // rec {
  version = "6.8.0";
  sha256 = "13arzwki13688hr1lh871y06lrk019g4hkasmg11arm8j1dcwcpq";
  extraBuildInputs = stdenv.lib.optionals stdenv.isDarwin
    [ CoreServices ApplicationServices ];
  preBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i -e "s|tr1/type_traits|type_traits|g" \
      -e "s|std::tr1|std|" src/util.h
  '';
  patches = [
    (fetchpatch {
      url = "https://github.com/nodejs/node/commit/fc164acbbb700fd50ab9c04b47fc1b2687e9c0f4.patch";
      sha256 = "1rms3n09622xmddn013yvf5c6p3s8w8s0d2h813zs8c1l15k4k1i";
    })
  ];
})
