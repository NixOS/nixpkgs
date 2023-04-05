{ egl-wayland
, libepoxy
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
, libxcvt
, mesa
, meson
, ninja
, openssl
, pkg-config
, pixman
, stdenv
, wayland
, wayland-protocols
, wayland-scanner
, xkbcomp
, xkeyboard_config
, xorgproto
, xtrans
, zlib
, defaultFontPath ? "" }:

stdenv.mkDerivation rec {
  pname = "xwayland";
  version = "22.1.9";

  src = fetchurl {
    url = "mirror://xorg/individual/xserver/${pname}-${version}.tar.xz";
    sha256 = "sha256-gTEO/h8paUvfb1huVPkyE1jELH32lhCPsdoSziEtP3g=";
  };

  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland-scanner
  ];
  buildInputs = [
    egl-wayland
    libepoxy
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
    libxcvt
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
    "-Dxwayland_eglstream=true"
    "-Ddefault_font_path=${defaultFontPath}"
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
