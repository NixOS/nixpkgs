{ lib
, stdenv
, fetchurl
, libglut
, libGL
, libGLU
, libX11
, libXext
, mesa
, meson
, ninja
, pkg-config
, wayland
, wayland-scanner
, wayland-protocols
, vulkan-loader
, libxkbcommon
, libdecor
, glslang
}:

stdenv.mkDerivation rec {
  pname = "mesa-demos";
  version = "9.0.0";

  src = fetchurl {
    url = "https://archive.mesa3d.org/demos/${pname}-${version}.tar.xz";
    sha256 = "sha256-MEaj0mp7BRr3690lel8jv+sWDK1u2VIynN/x6fHtSWs=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    glslang
  ];

  buildInputs = [
    libglut
    libX11
    libXext
    libGL
    libGLU
    mesa
    wayland
    wayland-protocols
    vulkan-loader
    libxkbcommon
    libdecor
  ];

  mesonFlags = [
    "-Dwith-system-data-files=true"
    "-Dgles1=disabled"
    "-Dosmesa=disabled"
  ];

  meta = with lib; {
    inherit (mesa.meta) homepage platforms;
    description = "Collection of demos and test programs for OpenGL and Mesa";
    license = licenses.mit;
    maintainers = with maintainers; [ andersk ];
  };
}
