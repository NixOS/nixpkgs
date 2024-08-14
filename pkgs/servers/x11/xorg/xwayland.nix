{ egl-wayland
, bash
, libepoxy
, fetchurl
, fontutil
, lib
, libdecor
, libei
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
, withLibunwind ? true, libunwind
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
, systemd
, wayland
, wayland-protocols
, wayland-scanner
, xkbcomp
, xkeyboard_config
, xorgproto
, xtrans
, zlib
, defaultFontPath ? ""
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "xwayland";
  version = "24.1.2";

  src = fetchurl {
    url = "mirror://xorg/individual/xserver/${pname}-${version}.tar.xz";
    hash = "sha256-FB63bn5CKjZhwIeCxwvkCTEIR1UELARQbg2X3UY+99I=";
  };

  postPatch = ''
    substituteInPlace os/utils.c \
      --replace-fail '/bin/sh' '${lib.getExe' bash "sh"}'
  '';

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
    libdecor
    libepoxy
    libei
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
    libxcb
    libxkbfile
    libxshmfence
    libxcvt
    mesa
    openssl
    pixman
    systemd
    wayland
    wayland-protocols
    xkbcomp
    xorgproto
    xtrans
    zlib
  ] ++ lib.optionals withLibunwind [
    libunwind
  ];
  mesonFlags = [
    (lib.mesonBool "xcsecurity" true)
    (lib.mesonOption "default_font_path" defaultFontPath)
    (lib.mesonOption "xkb_bin_dir" "${xkbcomp}/bin")
    (lib.mesonOption "xkb_dir" "${xkeyboard_config}/etc/X11/xkb")
    (lib.mesonOption "xkb_output_dir" "${placeholder "out"}/share/X11/xkb/compiled")
    (lib.mesonBool "libunwind" withLibunwind)
  ];

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://gitlab.freedesktop.org/xorg/xserver.git";
    rev-prefix = "xwayland-";
  };

  meta = with lib; {
    description = "X server for interfacing X11 apps with the Wayland protocol";
    homepage = "https://wayland.freedesktop.org/xserver.html";
    license = licenses.mit;
    mainProgram = "Xwayland";
    maintainers = with maintainers; [ emantor k900 ];
    platforms = platforms.linux;
  };
}
