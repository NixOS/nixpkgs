{ lib, stdenv, fetchurl, libxcb, xcbutil, xcbutilwm, git }:

stdenv.mkDerivation rec {
   pname = "xtitle";
   version = "0.4.4";

   src = fetchurl {
     url = "https://github.com/baskerville/xtitle/archive/${version}.tar.gz";
     sha256 = "0w490a6ki90si1ri48jzhma473a598l1b12j8dp4ckici41z9yy2";
   };


   buildInputs = [ libxcb git xcbutil xcbutilwm ];

   prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

   meta = {
     description = "Outputs X window titles";
     homepage = "https://github.com/baskerville/xtitle";
     maintainers = [ lib.maintainers.meisternu ];
     license = "Custom";
     platforms = lib.platforms.linux;
   };
}
