{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
   name = "sutils-0.1";

   src = fetchurl {
     url = "https://github.com/baskerville/sutils/archive/0.1.tar.gz";
     sha256 = "0xqk42vl82chy458d64fj68a4md4bxaip8n3xw9skxz0a1sgvks8";
   };

   hardeningDisable = [ "format" ];

   prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

   meta = {
     description = "Small command-line utilities";
     homepage = https://github.com/baskerville/sutils;
     maintainers = [ stdenv.lib.maintainers.meisternu ];
     license = "Custom";
     platforms = stdenv.lib.platforms.linux;
   };
}
