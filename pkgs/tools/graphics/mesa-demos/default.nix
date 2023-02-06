{ lib, stdenv, fetchurl
, freeglut, glew, libGL, libGLU, libX11, libXext, mesa
, meson, ninja, pkg-config, wayland-scanner, wayland, wayland-protocols
, vulkan-loader, libxkbcommon, libdecor, glslang }:

stdenv.mkDerivation rec {
  pname = "mesa-demos";
  version = "9.0.0";

  src = fetchurl {
    url = "https://archive.mesa3d.org/demos/${pname}-${version}.tar.xz";
    sha256 = "sha256-MEaj0mp7BRr3690lel8jv+sWDK1u2VIynN/x6fHtSWs=";
  };

  depsBuildBuild = [ pkg-config];
  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner ];
  buildInputs = [
    freeglut glew libX11 libXext libGL libGLU mesa
    vulkan-loader libxkbcommon libdecor glslang
  ] ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform wayland) [
    wayland wayland-protocols
  ] ++ lib.optional (mesa ? osmesa) mesa.osmesa;

  mesonFlags = [
    "-Degl=${if stdenv.isDarwin then "disabled" else "auto"}"
    (lib.mesonEnable "libdrm" (mesa.libdrm != null))
    (lib.mesonEnable "osmesa" (mesa ? osmesa))
    (lib.mesonEnable "wayland" (lib.meta.availableOn stdenv.hostPlatform wayland))
    "-Dwith-system-data-files=true"
  ];

  meta = with lib; {
    inherit (mesa.meta) homepage platforms;
    description = "Collection of demos and test programs for OpenGL and Mesa";
    license = licenses.mit;
    maintainers = with maintainers; [ andersk ];
  };
}
