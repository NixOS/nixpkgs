{ egl-wayland
, epoxy
, fetchurl
, fontutil
, lib
, libGL
, libGLU
, libX11
, libXau
, libXaw
, libXdmcp
, libXext
, libXfixes
, libXfont2
, libXmu
, libXpm
, libXrender
, libXres
, libXt
, libdrm
, libtirpc
, libunwind
, libxcb
, libxkbfile
, libxshmfence
, mesa
, meson
, ninja
, openssl
, pkg-config
, pixman
, stdenv
, wayland
, wayland-protocols
, xkbcomp
, xkeyboard_config
, xorgproto
, xtrans
, zlib
, defaultFontPath ? "" }:

stdenv.mkDerivation rec {

  pname = "xwayland";
  version = "21.1.1";
  src = fetchurl {
    url = "mirror://xorg/individual/xserver/${pname}-${version}.tar.xz";
    sha256 = "sha256-MfJhzlG77namyj7AKqNn/6K176K5hBLfV8zv16GQA84=";
  };
  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [
    egl-wayland
    epoxy
    fontutil
    libGL
    libGLU
    libX11
    libXau
    libXaw
    libXdmcp
    libXext
    libXfixes
    libXfont2
    libXmu
    libXpm
    libXrender
    libXres
    libXt
    libdrm
    libtirpc
    libunwind
    libxcb
    libxkbfile
    libxshmfence
    mesa
    openssl
    pixman
    wayland
    wayland-protocols
    xkbcomp
    xorgproto
    xtrans
    zlib
  ];
  mesonFlags = [
    "-Dxwayland-eglstream=true"
    "-Ddefault-font-path=${defaultFontPath}"
    "-Dxkb_bin_dir=${xkbcomp}/bin"
    "-Dxkb_dir=${xkeyboard_config}/etc/X11/xkb"
    "-Dxkb_output_dir=${placeholder "out"}/share/X11/xkb/compiled"
  ];

  meta = with lib; {
    description = "An X server for interfacing X11 apps with the Wayland protocol";
    homepage = "https://wayland.freedesktop.org/xserver.html";
    license = licenses.mit;
    maintainers = with maintainers; [ emantor ];
    platforms = platforms.linux;
  };
}
