{ stdenv, fetchurl, autoreconfHook, zlib, pcre, w3m, man }:

stdenv.mkDerivation rec{

  name = "privoxy-3.0.24";

  src = fetchurl {
    url = "mirror://sourceforge/ijbswa/Sources/3.0.22%20%28stable%29/${name}-stable-src.tar.gz";
    sha256 = "a381f6dc78f08de0d4a2342d47a5949a6608073ada34b933137184f3ca9fb012";
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
