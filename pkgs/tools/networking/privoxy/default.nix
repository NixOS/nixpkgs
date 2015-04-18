{ stdenv, fetchurl, autoreconfHook, zlib, pcre, w3m, man }:

stdenv.mkDerivation {
  name = "privoxy-3.0.22";

  src = fetchurl {
    url = mirror://sourceforge/ijbswa/Sources/3.0.22%20%28stable%29/privoxy-3.0.22-stable-src.tar.gz;
    sha256 = "0hfcxyb0i7dr6jfxw0y4kqcr09p8gjvcs7igyizyl5in3zn4y88s";
  };

  buildInputs = [ autoreconfHook zlib pcre w3m man ];

  meta = with stdenv.lib; {
    homepage = http://www.privoxy.org/;
    description = "Non-caching web proxy with advanced filtering capabilities";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.phreedom ];
  };
}
