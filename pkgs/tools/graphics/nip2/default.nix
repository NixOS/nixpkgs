{ stdenv, fetchurl, pkgconfig, glib, libxml2, flex, bison, vips, gnome,
fftw, gsl, goffice, libgsf }:

stdenv.mkDerivation rec {
  name = "nip2-8.3.0";

  src = fetchurl {
    url = "http://www.vips.ecs.soton.ac.uk/supported/current/${name}.tar.gz";
    sha256 = "0vr12gyfvhxx2a28y74lzfg379d1fk0g9isc69k0vdgpn4y1i8aa";
  };

  buildInputs =
  [ pkgconfig glib libxml2 flex bison vips
    gnome.gtk fftw gsl goffice libgsf
  ];

  meta = with stdenv.lib; {
    homepage = http://www.vips.ecs.soton.ac.uk;
    description = "Graphical user interface for VIPS image processing system";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kovirobi ];
    platforms = platforms.linux;
  };
}
