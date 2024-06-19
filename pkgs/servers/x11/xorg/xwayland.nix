{ egl-wayland
, libepoxy
, fetchurl
, fetchpatch
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
  version = "24.1.0";

  src = fetchurl {
    url = "mirror://xorg/individual/xserver/${pname}-${version}.tar.xz";
    hash = "sha256-vvIcTxiAek7VccTi32CrY7VGa71QLszrJIW4kqt23MI=";
  };

  patches = [
    # Backport fix for pkg-config generation to make CMake happy
    # FIXME: remove when merged
    # Upstream PR: https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/1543
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/xorg/xserver/-/commit/8cb1c21a4240a5b6bf4aeeef51819639b4e0ad24.patch";
      hash = "sha256-MZPP9QgYO4RFJ/vcjkpu7SVSo5Dh09ZdZjOwTopjdYQ=";
    })
    # Backport fix for segfault when linux-dmabuf device is not accessible
    # FIXME: remove when merged
    # Upstream PR: https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/1565
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/xorg/xserver/-/commit/7605833315c05488eca30ed0a70a2a1430e89bbc.patch";
      hash = "sha256-4/A6aOiOGouPe2v4wIYDQY9rWkuNZJwk0h4gpfrl6hI=";
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
