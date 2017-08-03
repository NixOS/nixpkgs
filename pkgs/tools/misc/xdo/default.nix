{ stdenv, fetchFromGitHub, libxcb, xcbutilwm }:

stdenv.mkDerivation rec {
   name = "xdo-${version}";
   version = "0.5.5";

   src = fetchFromGitHub {
     owner = "baskerville";
     repo = "xdo";
     rev = version;
     sha256 = "17i7ym4jrrbsiqs0jnm6k49hp9qn32hswad4j0lavwgv4wawachz";
   };
   
   makeFlags = "PREFIX=$(out)";

   buildInputs = [ libxcb xcbutilwm ];

   meta = with stdenv.lib; {
     description = "Small X utility to perform elementary actions on windows";
     homepage = https://github.com/baskerville/xdo;
     maintainers = with maintainers; [ meisternu ];
     license = licenses.bsd2;
     platforms = platforms.linux;
   };
}
