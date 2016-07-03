{ stdenv, fetchurl, cmake, pkgconfig, requireFile, makeWrapper, innoextract
, SDL2, SDL2_ttf, fontconfig, jansson, speexdsp, openssl, curl }:

rec {
  openrct2 = import ./gog.nix { inherit
    stdenv requireFile makeWrapper innoextract openrct2-engine;
  };

  openrct2-engine = import ./engine.nix { inherit
    stdenv fetchurl cmake pkgconfig
    SDL2 SDL2_ttf fontconfig jansson speexdsp openssl curl;
  };
}