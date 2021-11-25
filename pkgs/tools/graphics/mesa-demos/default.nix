{ lib, stdenv, fetchurl, freeglut, glew, libGL, libGLU, libX11, libXext, mesa, pkg-config, wayland }:

stdenv.mkDerivation rec {
  pname = "mesa-demos";
  version = "8.4.0";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/demos/${pname}-${version}.tar.bz2";
    sha256 = "0zgzbz55a14hz83gbmm0n9gpjnf5zadzi2kjjvkn6khql2a9rs81";
  };

  buildInputs = [ freeglut glew libX11 libXext libGL libGLU mesa mesa.osmesa wayland ];
  nativeBuildInputs = [ pkg-config ];

  configureFlags = [ "--with-system-data-files" ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Collection of demos and test programs for OpenGL and Mesa";
    homepage = "https://www.mesa3d.org/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ andersk ];
  };
}
