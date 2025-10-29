{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  pkg-config,
  buildPackages,
  cmake,
  extra-cmake-modules,
  wayland-scanner,
  cairo,
  pango,
  expat,
  fribidi,
  wayland,
  systemd,
  wayland-protocols,
  json_c,
  isocodes,
  xkeyboard_config,
  enchant,
  gdk-pixbuf,
  libGL,
  libuuid,
  libselinux,
  libXdmcp,
  libsepol,
  libxkbcommon,
  libthai,
  libdatrie,
  xcbutilkeysyms,
  xcbutil,
  xcbutilwm,
  xcb-imdkit,
  libxkbfile,
  nixosTests,
  gettext,
}:
let
  enDictVer = "20121020";
  enDict = fetchurl {
    url = "https://download.fcitx-im.org/data/en_dict-${enDictVer}.tar.gz";
    hash = "sha256-xEpdeEeSXuqeTS0EdI1ELNKN2SmaC1cu99kerE9abOs=";
  };
in
stdenv.mkDerivation rec {
  pname = "fcitx5";
  version = "5.1.16";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-aedYDpxYeUXadJnV+u1cQrNGoiW8WZKAgP4eNcvkScI=";
  };

  prePatch = ''
    ln -s ${enDict} src/modules/spell/$(stripHash ${enDict})
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wayland-scanner
    gettext
  ];

  buildInputs = [
    expat
    isocodes
    cairo
    enchant
    pango
    libthai
    libdatrie
    fribidi
    systemd
    gdk-pixbuf
    wayland
    wayland-protocols
    json_c
    libGL
    libuuid
    libselinux
    libsepol
    libXdmcp
    libxkbcommon
    xcbutil
    xcbutilwm
    xcbutilkeysyms
    xcb-imdkit
    xkeyboard_config
    libxkbfile
  ];

  cmakeFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    (lib.cmakeFeature "CMAKE_CROSSCOMPILING_EMULATOR" (stdenv.hostPlatform.emulator buildPackages))
  ];

  strictDeps = true;

  passthru = {
    updateScript = ./update.py;
    tests = {
      inherit (nixosTests) fcitx5;
    };
  };

  meta = with lib; {
    description = "Next generation of fcitx";
    homepage = "https://github.com/fcitx/fcitx5";
    license = licenses.lgpl21Plus;
    mainProgram = "fcitx5";
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
