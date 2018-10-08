{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
   version = "0.1";
   name = "sutils-${version}";

   src = fetchFromGitHub {
     owner = "baskerville";
     repo = "sutils";
     rev = version;
     sha256 = "0rvkc1y7rpw62d00n37pwfzvpvbbhzm6jvr2sb195l2dw53ya8d6";
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
