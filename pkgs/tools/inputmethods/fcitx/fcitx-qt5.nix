{ stdenv, lib, fetchurl, cmake, fcitx, pkgconfig, qtbase, extra-cmake-modules }:

stdenv.mkDerivation rec {
  name = "fcitx-qt5-${version}";
  version = "1.2.1";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-qt5/${name}.tar.xz";
    sha256 = "0z8ax0dxk88byic41mfaiahjdv1k8ciwn97xfjkkgr4ijgscdr8c";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkgconfig ];

  buildInputs = [ fcitx qtbase ];

  preInstall = ''
    substituteInPlace platforminputcontext/cmake_install.cmake \
      --replace ${qtbase.out} $out
    substituteInPlace quickphrase-editor/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with stdenv.lib; {
    homepage    = https://github.com/fcitx/fcitx-qt5;
    description = "Qt5 IM Module for Fcitx";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };

}
