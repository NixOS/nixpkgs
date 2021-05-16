{ stdenv
, lib
, fetchFromGitHub
, meson
, pkg-config
, xorgproto
, xtrans
, libxshmfence
, pixman
, xkbcomp
, libxkbfile
, libXfont2
, dbus
, systemd
, fontutil
, mesa
, epoxy
, libmd
, nettle
, libgcrypt
, openssl
, libXdmcp
, libdrm
, libselinux
, audit
, libGL
, libtirpc
, libXau
, arcan
, libxcb
, ninja
, libX11
, xcbutil
, xcbutilwm
}:

stdenv.mkDerivation rec {
  pname = "xarcan";
  version = "0.6.0+unstable=2021-06-14";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = pname;
    rev = "98d28a5f2c6860bb191fbc1c9e577c18e4c9a9b7";
    sha256 = "sha256-UTIVDKnYD/q0K6G7NJUKh1tHcqnsuiJ/cQxWuPMJ2G4=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
  ];

  buildInputs = [
    xorgproto
    xtrans
    libxshmfence
    pixman
    xkbcomp
    libxkbfile
    libXfont2
    dbus
    systemd
    fontutil
    mesa
    epoxy
    libmd
    nettle
    libgcrypt
    openssl
    libXdmcp
    libdrm
    libselinux
    audit
    libGL
    libtirpc
    libXau
    arcan
    libxcb
    ninja
    libX11
    xcbutil
    xcbutilwm
  ];

  meta = with lib; {
    description = "Patched Xserver that bridges connections to Arcan";
    homepage = "https://github.com/letoram/letoram";
    changelog = "https://github.com/letoram/letoram/releases/tag/${version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ a12l ];
  };
}
