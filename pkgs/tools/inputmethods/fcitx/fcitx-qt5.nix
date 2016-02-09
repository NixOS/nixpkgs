{ stdenv, fetchurl, cmake, fcitx, extra-cmake-modules, qtbase }:

stdenv.mkDerivation rec {
  name = "fcitx-qt5-${version}";
  version = "1.0.4";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-qt5/${name}.tar.xz";
    sha256 = "070dlmwkim7sg0xwxfcbb46li1jk8yd3rmj0j5fkmgyr12044aml";
  };

  buildInputs = [ cmake fcitx extra-cmake-modules qtbase ];

  preInstall = ''
    substituteInPlace platforminputcontext/cmake_install.cmake \
      --replace ${qtbase} $out
  '';

  meta = with stdenv.lib; {
    homepage    = "https://github.com/fcitx/fcitx-qt5";
    description = "Qt5 IM Module for Fcitx";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };

}
