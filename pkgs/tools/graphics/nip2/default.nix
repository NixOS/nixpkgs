{ lib
, stdenv
, fetchurl
, pkg-config
, glib
, libxml2
, flex
, bison
, vips
, gtk2
, fftw
, gsl
, goffice
, libgsf
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "nip2";
  version = "8.9.1";

  src = fetchurl {
    url = "https://github.com/libvips/nip2/releases/download/v${version}/nip2-${version}.tar.gz";
    sha256 = "sha256-t14m6z+5lPqpiOjgdDbKwqSWXCyrCL7zlo6BeoZtds0=";
  };

  nativeBuildInputs = [
    bison
    flex
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    glib
    libxml2
    vips
    gtk2
    fftw
    gsl
    goffice
    libgsf
  ];

  postFixup = ''
    wrapProgram $out/bin/nip2 --set VIPSHOME "$out"
  '';

  meta = with lib; {
    homepage = "https://github.com/libvips/nip2";
    description = "Graphical user interface for VIPS image processing system";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kovirobi ];
    platforms = platforms.unix;
    mainProgram = "nip2";
  };
}
