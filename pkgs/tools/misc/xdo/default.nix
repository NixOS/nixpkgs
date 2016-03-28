{ stdenv, fetchurl, libxcb, xcbutilwm }:

stdenv.mkDerivation rec {
   name = "xdo-0.5";

   src = fetchurl {
     url = "https://github.com/baskerville/xdo/archive/0.5.tar.gz";
     sha256 = "0sjnjs12i0gp1dg1m5jid4a3bg9am4qkf0qafyp6yn176yzcz1i6";
   };

   prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

   buildInputs = [ libxcb xcbutilwm ];

   meta = {
     description = "Small X utility to perform elementary actions on windows";
     homepage = https://github.com/baskerville/xdo;
     maintainers = [ stdenv.lib.maintainers.meisternu ];
     license = "Custom";
     platforms = stdenv.lib.platforms.linux;
   };
}
