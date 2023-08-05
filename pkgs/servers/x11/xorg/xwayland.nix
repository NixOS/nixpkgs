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
  version = "23.1.2";

  src = fetchurl {
    url = "mirror://xorg/individual/xserver/${pname}-${version}.tar.xz";
    sha256 = "sha256-vSXYSY7k13h0/aElEn4ts3/DMlMf68lmIx6gb66M938=";
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
    (lib.mesonBool "xwayland_eglstream" true)
    (lib.mesonBool "xcsecurity" true)
    (lib.mesonOption "default_font_path" defaultFontPath)
    (lib.mesonOption "xkb_bin_dir" "${xkbcomp}/bin")
    (lib.mesonOption "xkb_dir" "${xkeyboard_config}/etc/X11/xkb")
    (lib.mesonOption "xkb_output_dir" "${placeholder "out"}/share/X11/xkb/compiled")
    (lib.mesonBool "libunwind" (libunwind != null))
  ];

  meta = with lib; {
    description = "An X server for interfacing X11 apps with the Wayland protocol";
    homepage = "https://wayland.freedesktop.org/xserver.html";
    license = licenses.mit;
    mainProgram = "Xwayland";
    maintainers = with maintainers; [ emantor ];
    platforms = platforms.linux;
  };
}
