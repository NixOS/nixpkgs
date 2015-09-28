{ stdenv, fetchurl, pkgconfig, glib, libxml2, flex, bison, vips, gnome,
fftw, gsl, goffice_0_8, libgsf }:

stdenv.mkDerivation rec {
  name = "nip2-8.0";

  src = fetchurl {
    url = "http://www.vips.ecs.soton.ac.uk/supported/current/${name}.tar.gz";
    sha256 = "10ybac0qrz63x1yk1d0gpv9z1vzpadyii2qhrai6lllplzw6jqx7";
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
