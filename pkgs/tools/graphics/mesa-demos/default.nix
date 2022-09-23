{ lib, stdenv, fetchurl, freeglut, glew, libGL, libGLU, libX11, libXext, mesa
, meson, ninja, pkg-config, wayland, wayland-protocols }:

stdenv.mkDerivation rec {
  pname = "mesa-demos";
  version = "8.5.0";

  src = fetchurl {
    url = "https://archive.mesa3d.org/demos/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-zqLfCoDwmjD2NcTrGmcr+Qxd3uC4539NcAQWaO9xqsE=";
  };

  patches = [
    # https://gitlab.freedesktop.org/mesa/demos/-/merge_requests/83
    ./demos-data-dir.patch
  ];

  buildInputs = [
    freeglut glew libX11 libXext libGL libGLU mesa mesa.osmesa wayland
    wayland-protocols
  ];
  nativeBuildInputs = [ meson ninja pkg-config ];

  mesonFlags = [ "-Dwith-system-data-files=true" ];

  meta = with lib; {
    description = "Collection of demos and test programs for OpenGL and Mesa";
    homepage = "https://www.mesa3d.org/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ andersk ];
  };
}
