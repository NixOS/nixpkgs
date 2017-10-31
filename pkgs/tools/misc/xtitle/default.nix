{ stdenv, fetchurl, libxcb, xcbutil, xcbutilwm, git }:

stdenv.mkDerivation rec {
   name = "xtitle-0.3";

   src = fetchurl {
     url = "https://github.com/baskerville/xtitle/archive/0.3.tar.gz";
     sha256 = "07r36f4ad1q0dpkx3ykd49xlmi24d8mjqwh40j228k81wsvzayl1";
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
