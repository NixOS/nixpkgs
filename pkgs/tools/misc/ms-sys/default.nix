{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  name = "ms-sys-${version}";
  version = "2.5.3";
 
  src = fetchurl {
    url = "mirror://sourceforge/ms-sys/${name}.tar.gz";
    sha256 = "0mijf82cbji4laip6hiy3l5ka5mzq5sivjvyv7wxnc2fd3v7hgp0";
  };

  buildInputs = [ gettext ];

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A program for writing Microsoft-compatible boot records";
    homepage = http://ms-sys.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nckx ];
  };
}
