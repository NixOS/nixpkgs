{ lib, stdenv, fetchurl
, freeglut, glew, libGL, libGLU, libX11, libXext, mesa
, meson, ninja, pkg-config, wayland, wayland-protocols
, vulkan-loader, libxkbcommon, libdecor, glslang }:

stdenv.mkDerivation rec {
  pname = "mesa-demos";
  version = "9.0.0";

  src = fetchurl {
    url = "https://archive.mesa3d.org/demos/${pname}-${version}.tar.xz";
    sha256 = "sha256-MEaj0mp7BRr3690lel8jv+sWDK1u2VIynN/x6fHtSWs=";
  };

  buildInputs = [
    freeglut glew libX11 libXext libGL libGLU mesa wayland
    wayland-protocols vulkan-loader libxkbcommon libdecor glslang
  ] ++ lib.optional (mesa ? osmesa) mesa.osmesa ;
  nativeBuildInputs = [ meson ninja pkg-config wayland ];

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
