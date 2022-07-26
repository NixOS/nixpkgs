{ lib, stdenv
, fetchurl
, fetchFromGitHub
, pkg-config
, cmake
, extra-cmake-modules
, cairo
, cldr-annotations
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
}:
let
  enDictVer = "20121020";
  enDict = fetchurl {
    url = "https://download.fcitx-im.org/data/en_dict-${enDictVer}.tar.gz";
    sha256 = "1svcb97sq7nrywp5f2ws57cqvlic8j6p811d9ngflplj8xw5sjn4";
  };
in
stdenv.mkDerivation rec {
  pname = "fcitx5";
  version = "5.0.18";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZhjNUWzi74lr8Wtf0f+VN1kc9C6q2TJ9ogXeu3NJKbI=";
  };

  prePatch = ''
    ln -s ${enDict} src/modules/spell/dict/$(stripHash ${enDict})
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
    cldr-annotations
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

  cmakeFlags = [ "-DCLDR_DIR=${cldr-annotations}/share/unicode/cldr" ];

  passthru.updateScript = ./update.py;

  meta = with lib; {
    description = "Next generation of fcitx";
    homepage = "https://github.com/fcitx/fcitx5";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
