{ stdenv, fetchFromGitHub, alsaLib }:

stdenv.mkDerivation rec {
   version = "0.2";
   pname = "sutils";

   src = fetchFromGitHub {
     owner = "baskerville";
     repo = "sutils";
     rev = version;
     sha256 = "0i2g6a6xdaq3w613dhq7mnsz4ymwqn6kvkyan5kgy49mzq97va6j";
   };

   hardeningDisable = [ "format" ];

   buildInputs = [ alsaLib ];

   prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

   meta = {
     description = "Small command-line utilities";
     homepage = "https://github.com/baskerville/sutils";
     maintainers = [ stdenv.lib.maintainers.meisternu ];
     license = "Custom";
     platforms = stdenv.lib.platforms.linux;
   };
}
