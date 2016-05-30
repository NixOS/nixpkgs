{ stdenv, fetchurl, pkgconfig, libxml2 }:

stdenv.mkDerivation rec {
  name = "xml2-0.5";

  src = fetchurl {
    url = "http://download.ofb.net/gale/${name}.tar.gz";
    sha256 = "01cps980m99y99cnmvydihga9zh3pvdsqag2fi1n6k2x7rfkl873";
  };

  buildInputs = [ pkgconfig libxml2 ];

  meta = with stdenv.lib; {
    homepage = http://ofb.net/~egnor/xml2/;
    description = "Tools for command line processing of XML, HTML, and CSV";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
