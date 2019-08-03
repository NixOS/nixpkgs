{ stdenv, fetchurl, libxcb, xcbutil, xcbutilwm, git }:

stdenv.mkDerivation rec {
   name = "xtitle-0.4.4";

   src = fetchurl {
     url = "https://github.com/baskerville/xtitle/archive/0.4.4.tar.gz";
     sha256 = "0w490a6ki90si1ri48jzhma473a598l1b12j8dp4ckici41z9yy2";
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
