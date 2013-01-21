{ stdenv, fetchurl, cmake, qt4 }:
stdenv.mkDerivation rec {

  name = "vidalia-${version}";
  version = "0.2.21";

  src = fetchurl {
    url = "https://www.torproject.org/dist/vidalia/${name}.tar.gz";
    sha256 = "1rqvvhdqgk6jqrd15invvc4r7p4nckd3b93hhr5dzpc1fxz8w064";
  };

  buildInputs = [ cmake qt4 ];

  meta = with stdenv.lib; {
    homepage = https://www.torproject.org/projects/vidalia.html.en;
    description = "a cross-platform graphical controller for the Tor software, built using the Qt framework";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.all;
  };
}
