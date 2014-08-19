{ stdenv, fetchurl, libxcb, xcbutil, xcbutilwm, git }:

stdenv.mkDerivation rec {
   name = "xtitle-0.2";

   src = fetchurl {
     url = "https://github.com/baskerville/xtitle/archive/0.2.tar.gz";
     sha256 = "1wyhfwbwqnq4rn6i789gydxlg25ylc37xjrkq758bp55sdgb8fk2";
   };


   buildInputs = [ libxcb git xcbutil xcbutilwm ];

   prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

   meta = {
     description = "Outputs X window titles";
     homepage = "https://github.com/baskerville/xtitle";
     maintainers = stdenv.lib.maintainers.meisternu;
     license = "Custom";
     platforms = stdenv.lib.platforms.linux;
   };
}
