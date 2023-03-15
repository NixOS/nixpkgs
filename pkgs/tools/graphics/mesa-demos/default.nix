{ lib, stdenv, fetchurl, fetchpatch
, freeglut, glew, libGL, libGLU, libX11, libXext, mesa
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

    (fetchpatch {
      url = "https://gitlab.freedesktop.org/mesa/demos/-/commit/b6d183f9943a275990aef7f08773e54c597572e5.patch";
      sha256 = "4UdV+cxvNRqoT+Pdy0gkCPXJbhFr6CSCw/UOOB+rvuw=";
    })
  ];

  buildInputs = [
    freeglut glew libX11 libXext libGL libGLU mesa wayland
    wayland-protocols
  ] ++ lib.optional (mesa ? osmesa) mesa.osmesa ;
  nativeBuildInputs = [ meson ninja pkg-config ];

  mesonFlags = [
    "-Degl=${if stdenv.isDarwin then "disabled" else "auto"}"
    "-Dlibdrm=${if mesa.libdrm == null then "disabled" else "enabled"}"
    "-Dosmesa=${if mesa ? osmesa then "enabled" else "disabled"}"
    "-Dwayland=${if wayland.withLibraries then "enabled" else "disabled"}"
    "-Dwith-system-data-files=true"
  ];

  meta = with lib; {
    inherit (mesa.meta) homepage platforms;
    description = "Collection of demos and test programs for OpenGL and Mesa";
    license = licenses.mit;
    maintainers = with maintainers; [ andersk ];
  };
}
