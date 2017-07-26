{ stdenv, lib, fetchurl, cmake, fcitx, pkgconfig, qtbase, extra-cmake-modules }:

stdenv.mkDerivation rec {
  name = "fcitx-qt5-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-qt5/${name}.tar.xz";
    sha256 = "0r8c5k0qin3mz2p1mdciip6my0x58662sx5z50zs4c5pkdg21qwv";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkgconfig ];

  buildInputs = [ fcitx qtbase ];

  preInstall = ''
    substituteInPlace platforminputcontext/cmake_install.cmake \
      --replace ${qtbase.out} $out
  '';

  meta = with stdenv.lib; {
    homepage    = "https://github.com/fcitx/fcitx-qt5";
    description = "Qt5 IM Module for Fcitx";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };

}
