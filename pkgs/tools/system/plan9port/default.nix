{stdenv, fetchurl, libX11, xproto, libXt, xextproto, libXext}:

stdenv.mkDerivation rec {
  name = "plan9port-20110103";
  
  builder = ./builder.sh;

  src = fetchurl {
    url = "http://swtch.com/plan9port/${name}.tgz";
    sha256 = "12hq3k03jgva72498qa1dyndakbhbfg0sc1jhcap9cxqj04xf0dc";
  };

  buildInputs = [ libX11 xproto libXt xextproto libXext ];

  meta = {
    homepage = "http://swtch.com/plan9port/";
    description = "Plan 9 from User Space";
    license="free";
  };
}
