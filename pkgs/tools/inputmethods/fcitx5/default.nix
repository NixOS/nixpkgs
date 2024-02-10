{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, fetchpatch
, pkg-config
, cmake
, extra-cmake-modules
, cairo
, pango
, expat
, fribidi
, fmt
, wayland
, systemd
, wayland-protocols
, json_c
, isocodes
, xkeyboard_config
, enchant
, gdk-pixbuf
, libGL
, libuuid
, libselinux
, libXdmcp
, libsepol
, libxkbcommon
, libthai
, libdatrie
, xcbutilkeysyms
, pcre
, xcbutil
, xcbutilwm
, xcb-imdkit
, libxkbfile
, nixosTests
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
  version = "5.1.7";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-XI4E+fWDIYDiYBv6HezytaZmhzv4NUaNam1T5Fyx+LI=";
  };

  prePatch = ''
    ln -s ${enDict} src/modules/spell/$(stripHash ${enDict})
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    expat
    fmt
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
    pcre
    xcbutil
    xcbutilwm
    xcbutilkeysyms
    xcb-imdkit
    xkeyboard_config
    libxkbfile
  ];

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
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
