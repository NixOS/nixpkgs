{ stdenv, fetchurl, libxcb, xcbutilwm }:

stdenv.mkDerivation rec {
   name = "xdo-0.3";

   src = fetchurl {
     url = "https://github.com/baskerville/xdo/archive/0.3.tar.gz";
     sha256 = "128flaydag9ixsai87p85r84arg2pn1j9h3zgdjwlmbcpb8d4ia8";
   };

   prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

   buildInputs = [ libxcb xcbutilwm ];

   meta = {
     description = "Small X utility to perform elementary actions on windows";
     homepage = "https://github.com/baskerville/xdo";
     maintainers = stdenv.lib.maintainers.meisternu;
     license = "Custom";
     platforms = stdenv.lib.platforms.linux;
   };
}
