{ egl-wayland
, libepoxy
, fetchurl
, fetchpatch
, fontutil
, lib
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
  version = "23.2.6";

  src = fetchurl {
    url = "mirror://xorg/individual/xserver/${pname}-${version}.tar.xz";
    hash = "sha256-HJo2a058ytug+b0xPFnq4S0jvXJUOyKibq+LIINc/G0=";
  };

  patches = [
    # Backport fix for libei scrolling
    # Notably affects Steam Input, but also anything else using xtest
    # FIXME: remove when merged
    # Upstream PR: https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/1531
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/xorg/xserver/-/commit/317712eb5a1aa4a1c3d737a8fcaee57add9981c9.patch";
      hash = "sha256-TZo38Pyr9IJUF+3bqlmF4M84XGgo9G6WFTvbaP9r0XU=";
    })
  ];

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
    (lib.mesonBool "xwayland_eglstream" true)
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
    description = "An X server for interfacing X11 apps with the Wayland protocol";
    homepage = "https://wayland.freedesktop.org/xserver.html";
    license = licenses.mit;
    mainProgram = "Xwayland";
    maintainers = with maintainers; [ emantor ];
    platforms = platforms.linux;
  };
}
