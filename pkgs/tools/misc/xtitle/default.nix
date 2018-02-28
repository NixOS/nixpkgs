{ stdenv, fetchurl, libxcb, xcbutil, xcbutilwm, git }:

stdenv.mkDerivation rec {
   name = "xtitle-0.4.3";

   src = fetchurl {
     url = "https://github.com/baskerville/xtitle/archive/0.4.3.tar.gz";
     sha256 = "0bk4mxx0vky37f66b2y34nggi1f7fnrmsprkxyc8mskj6qcrbm5h";
   };


   buildInputs = [ libxcb git xcbutil xcbutilwm ];

   prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

   meta = {
     description = "Outputs X window titles";
     homepage = https://github.com/baskerville/xtitle;
     maintainers = [ stdenv.lib.maintainers.meisternu ];
     license = "Custom";
     platforms = stdenv.lib.platforms.linux;
   };
}
