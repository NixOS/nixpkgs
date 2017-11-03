{ stdenv, fetchFromGitHub, libxcb, xcbutil, xcbutilwm }:

stdenv.mkDerivation rec {
   name = "xdo-${version}";
   version = "0.5.6";

   src = fetchFromGitHub {
     owner = "baskerville";
     repo = "xdo";
     rev = version;
     sha256 = "1i8xlsp36ji7cvyh66ajqsf59hxpwm0xvnn9laq7nbajcx3qqlnh";
   };

   makeFlags = "PREFIX=$(out)";

   buildInputs = [ libxcb xcbutilwm xcbutil ];

   meta = with stdenv.lib; {
     description = "Small X utility to perform elementary actions on windows";
     homepage = https://github.com/baskerville/xdo;
     maintainers = with maintainers; [ meisternu ];
     license = licenses.bsd2;
     platforms = platforms.linux;
   };
}
