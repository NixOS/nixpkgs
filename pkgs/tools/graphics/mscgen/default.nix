{ stdenv, fetchurl, flex, bison, gd, libpng, freetype, zlib }:

let
  version = "0.20";
in
stdenv.mkDerivation {
  name = "mscgen-${version}";

  src = fetchurl {
    url = "http://www.mcternan.me.uk/mscgen/software/mscgen-src-${version}.tar.gz";
    sha256 = "3c3481ae0599e1c2d30b7ed54ab45249127533ab2f20e768a0ae58d8551ddc23";
  };

  buildInputs = [ flex bison gd libpng freetype zlib ];

  doCheck = true;
  preCheck = ''
    sed -i -e "s|#!/bin/bash|#!${stdenv.shell}|" test/renderercheck.sh
  '';

  meta = {
    homepage = http://www.mcternan.me.uk/mscgen/;
    description = "Convert Message Sequence Chart descriptions into PNG, SVG, or EPS images";
    license = stdenv.lib.licenses.gpl2;

    longDescription = ''
      Mscgen is a small program that parses Message Sequence Chart
      descriptions and produces PNG, SVG, EPS or server side image maps
      (ismaps) as the output. Message Sequence Charts (MSCs) are a way
      of representing entities and interactions over some time period
      and are often used in combination with SDL. MSCs are popular in
      Telecoms to specify how protocols operate although MSCs need not
      be complicated to create or use. Mscgen aims to provide a simple
      text language that is clear to create, edit and understand, which
      can also be transformed into common image formats for display or
      printing.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
