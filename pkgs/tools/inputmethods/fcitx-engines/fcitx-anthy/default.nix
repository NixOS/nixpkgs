{ lib, stdenv, fetchurl, cmake, fcitx, anthy, gettext, pkg-config }:

stdenv.mkDerivation rec {
  pname = "fcitx-anthy";
  version = "0.2.4";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-anthy/${pname}-${version}.tar.xz";
    sha256 = "sha256-Hxhs2RXuFf/bhczcQ3+Zj+gI3+Z4BEfIzMIfUOUNX7M=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ fcitx anthy gettext ];

  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with lib; {
    isFcitxEngine = true;
    description   = "Fcitx Wrapper for anthy";
    license       = licenses.gpl2Plus;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ ericsagnes ];
  };

}
