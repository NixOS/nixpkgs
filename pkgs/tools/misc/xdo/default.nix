{ stdenv, fetchFromGitHub, libxcb, xcbutilwm }:

stdenv.mkDerivation rec {
   name = "xdo-${version}";
   version = "0.5.3";

   src = fetchFromGitHub {
     owner = "baskerville";
     repo = "xdo";
     rev = version;
     sha256 = "0gfrziil6xw6pkr8k8rn56ihy0333v6dlsw3dckib9hm7ikj0k2f";
   };

   prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

   buildInputs = [ libxcb xcbutilwm ];

   meta = {
     description = "Small X utility to perform elementary actions on windows";
     inherit (src.meta) homepage;
     maintainers = [ stdenv.lib.maintainers.meisternu ];
     license = stdenv.lib.licenses.bsd2;
     platforms = stdenv.lib.platforms.linux;
   };
}
