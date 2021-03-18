{ lib, stdenv, fetchurl, pkg-config, glib, libxml2, flex, bison, vips, gtk2
, fftw, gsl, goffice, libgsf }:

stdenv.mkDerivation rec {
  pname = "nip2";
  version = "8.7.1";

  src = fetchurl {
    url = "https://github.com/libvips/nip2/releases/download/v${version}/nip2-${version}.tar.gz";
    sha256 = "0l7n427njif53npqn02gfjjly8y3khbrkzqxp10j5vp9h97psgiw";
  };

  buildInputs =
  [ pkg-config glib libxml2 flex bison vips
    gtk2 fftw gsl goffice libgsf
  ];

  meta = with lib; {
    homepage = "https://github.com/libvips/nip2";
    description = "Graphical user interface for VIPS image processing system";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kovirobi ];
    platforms = platforms.unix;
  };
}
