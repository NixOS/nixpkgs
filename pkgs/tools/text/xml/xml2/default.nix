{ lib, stdenv, fetchurl, pkg-config, libxml2 }:

stdenv.mkDerivation rec {
  pname = "xml2";
  version = "0.5";

  src = fetchurl {
    url = "https://web.archive.org/web/20160427221603/http://download.ofb.net/gale/xml2-${version}.tar.gz";
    sha256 = "01cps980m99y99cnmvydihga9zh3pvdsqag2fi1n6k2x7rfkl873";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxml2 ];

  meta = with lib; {
    homepage = "https://web.archive.org/web/20160515005047/http://dan.egnor.name:80/xml2";
    description = "Tools for command line processing of XML, HTML, and CSV";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
