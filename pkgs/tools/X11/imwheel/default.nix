{ stdenv, fetchurl, libX11, libXext, libXi, libXmu, libXt, libXtst }:

stdenv.mkDerivation rec {
  name = "imwheel-1.0.0pre12";

  src = fetchurl {
    url = "mirror://sourceforge/imwheel/${name}.tar.gz";
    sha256 = "2320ed019c95ca4d922968e1e1cbf0c075a914e865e3965d2bd694ca3d57cfe3";
  };

  buildInputs = [ libX11 libXext libXi libXmu libXt libXtst ];

  makeFlags = [
    "sysconfdir=/etc"
    "ETCDIR=/etc"
  ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "ETCDIR=${placeholder "out"}/etc"
  ];

  meta = with stdenv.lib; {
    homepage = "http://imwheel.sourceforge.net/";
    description = "Mouse wheel configuration tool for XFree86/Xorg";
    maintainers = with maintainers; [ jhillyerd ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
