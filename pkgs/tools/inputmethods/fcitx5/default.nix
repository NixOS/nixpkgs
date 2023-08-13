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
, libevent
, libuuid
, libselinux
, libXdmcp
, libsepol
, libxkbcommon
, libthai
, libdatrie
, xcbutilkeysyms
, pcre
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
  version = "5.0.23";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-zS25XeNtBN7QIi+Re/p1uLoH/Q4xKAsFrEmgk2LYRu8=";
  };

  patches = [
    # Fix compatiblity with fmt 10.0. Remove with the next release
    (fetchpatch {
      url = "https://github.com/fcitx/fcitx5/commit/7fb3a5500270877d93b61b11b2a17b9b8f6a506b.patch";
      hash = "sha256-Z4Sqdyp/doJPTB+hEUrG9vncUP29L/b0yJ/u5ldpnds=";
    })
  ];

  prePatch = ''
    ln -s ${enDict} src/modules/spell/$(stripHash ${enDict})
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
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
    libevent
    libuuid
    libselinux
    libsepol
    libXdmcp
    libxkbcommon
    pcre
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
