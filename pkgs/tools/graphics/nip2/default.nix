{ stdenv, fetchurl, pkgconfig, glib, libxml2, flex, bison, vips, gnome,
fftw, gsl, goffice_0_8, libgsf }:

stdenv.mkDerivation rec {
  name = "nip2-7.42.1";

  src = fetchurl {
    url = "http://www.vips.ecs.soton.ac.uk/supported/current/${name}.tar.gz";
    sha256 = "14lfyn0azswrz8r81ign9lbpxzk7ibmnnp03a3l8wgxvm2j9a7jl";
  };

  buildInputs =
  [ pkgconfig glib libxml2 flex bison vips
    gnome.gtk fftw gsl goffice_0_8 libgsf
  ];

  meta = with stdenv.lib; {
    homepage = http://www.vips.ecs.soton.ac.uk;
    description = "Graphical user interface for VIPS image processing system";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kovirobi ];
    platforms = platforms.linux;
  };
}
